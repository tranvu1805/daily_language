import 'dart:async';

import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'review_word_event.dart';
part 'review_word_state.dart';

class ReviewWordBloc extends Bloc<ReviewWordEvent, ReviewWordState> {
  final GetUserWordsUseCase _getUserWordsUseCase;
  final GetDictionaryWordByIdUseCase _getDictionaryWordByIdUseCase;
  final UpdateUserWordUseCase _updateUserWordUseCase;

  ReviewWordBloc({
    required GetUserWordsUseCase getUserWordsUseCase,
    required GetDictionaryWordByIdUseCase getDictionaryWordByIdUseCase,
    required UpdateUserWordUseCase updateUserWordUseCase,
  }) : _getUserWordsUseCase = getUserWordsUseCase,
       _getDictionaryWordByIdUseCase = getDictionaryWordByIdUseCase,
       _updateUserWordUseCase = updateUserWordUseCase,
       super(const ReviewWordState()) {
    on<ReviewWordLoaded>(_onReviewWordLoaded);
    on<ReviewWordRefreshed>(_onReviewWordRefreshed);
    on<ReviewWordAnswerSubmitted>(_onAnswerSubmitted);
    on<ReviewWordNextRequested>(_onNextRequested);
    on<ReviewWordFinishedRequested>(_onFinishedRequested);
  }

  Future<void> _onReviewWordRefreshed(
    ReviewWordRefreshed event,
    Emitter<ReviewWordState> emit,
  ) async {
    // Only fetch new data without resetting status to avoid infinite loop or flickering dialogs
    final result = await _getUserWordsUseCase(
      GetUserWordsUseCaseParams(
        userId: event.userId,
        limit: 20,
        isReview: true,
      ),
    );

    result.fold((_) {}, (words) => emit(state.copyWith(reviewWords: words)));
  }

  Future<void> _onReviewWordLoaded(
    ReviewWordLoaded event,
    Emitter<ReviewWordState> emit,
  ) async {
    emit(state.copyWith(status: ReviewWordStatus.loading));

    final result = await _getUserWordsUseCase(
      GetUserWordsUseCaseParams(
        userId: event.userId,
        limit: 20,
        isReview: true,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: ReviewWordStatus.failure,
            error: failure.message,
          ),
        );
      },
      (reviewWords) async {
        if (reviewWords.isEmpty) {
          emit(state.copyWith(status: ReviewWordStatus.finished));
          return;
        }

        emit(state.copyWith(reviewWords: reviewWords, currentIndex: 0));

        await _loadCurrentWordDetails(emit);
      },
    );
  }

  Future<void> _loadCurrentWordDetails(Emitter<ReviewWordState> emit) async {
    final userWord = state.reviewWords[state.currentIndex];
    // UserWord only contains the word string, we need details like meanings.
    final result = await _getDictionaryWordByIdUseCase(
      GetDictionaryWordByIdUseCaseParams(word: userWord.word),
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ReviewWordStatus.failure,
            error: failure.message,
          ),
        );
      },
      (word) {
        emit(
          state.copyWith(
            status: ReviewWordStatus.loaded,
            currentDictionaryWord: word,
            isShowingAnswer: false,
            isCorrect: false,
          ),
        );
      },
    );
  }

  Future<void> _onAnswerSubmitted(
    ReviewWordAnswerSubmitted event,
    Emitter<ReviewWordState> emit,
  ) async {
    if (state.currentDictionaryWord == null) return;
    final correctAnswer = state.currentDictionaryWord!.content
        .trim()
        .toLowerCase();
    final userAnswer = event.answer.trim().toLowerCase();
    final isCorrect = correctAnswer == userAnswer;
    final userWord = state.reviewWords[state.currentIndex];
    final updatedUserWord = _calculateNextReview(userWord, isCorrect);

    // Save to Firebase
    final result = await _updateUserWordUseCase(
      UpdateUserWordUseCaseParams(
        id: updatedUserWord.id,
        userId: updatedUserWord.userId,
        wordId: updatedUserWord.wordId,
        word: updatedUserWord.word,
        level: updatedUserWord.level,
        repetitionCount: updatedUserWord.repetitionCount,
        wrongCount: updatedUserWord.wrongCount,
        stage: updatedUserWord.stage,
        lastReviewed: updatedUserWord.lastReviewed,
        nextReview: updatedUserWord.nextReview,
        easeFactor: updatedUserWord.easeFactor,
        interval: updatedUserWord.interval,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (_) {
        // Update local state words list
        final updatedReviewWords = List<UserWord>.from(state.reviewWords);
        updatedReviewWords[state.currentIndex] = updatedUserWord;

        emit(
          state.copyWith(
            reviewWords: updatedReviewWords,
            isCorrect: isCorrect,
            isShowingAnswer: true,
          ),
        );
      },
    );
  }

  UserWord _calculateNextReview(UserWord userWord, bool isCorrect) {
    final now = DateTime.now();
    int repetitionCount = userWord.repetitionCount;
    int wrongCount = userWord.wrongCount;
    int stage = userWord.stage;

    // rememberLevel/stage logic
    if (isCorrect) {
      repetitionCount++;
      if (stage < 5) stage++;
    } else {
      wrongCount++;
      if (stage > 0) stage--;
    }

    // Spaced Repetition Intervals based on current level
    Duration reviewDuration;

    if (!isCorrect) {
      // If incorrect, set a short delay for immediate re-learning
      // This allows the user to re-try the word in the same session.
      reviewDuration = const Duration(minutes: 10);
    } else {
      // If correct, set the next review time based on the NEW stage reached
      switch (stage) {
        case 0:
          reviewDuration = const Duration(hours: 8);
          break;
        case 1:
          reviewDuration = const Duration(days: 2);
          break;
        case 2:
          reviewDuration = const Duration(days: 5);
          break;
        case 3:
          reviewDuration = const Duration(days: 10);
          break;
        case 4:
          reviewDuration = const Duration(days: 15);
          break;
        case 5:
          reviewDuration = const Duration(days: 30);
          break;
        default:
          reviewDuration = const Duration(days: 30);
      }
    }

    final nextReview = now.add(reviewDuration);
    final double interval = reviewDuration.inHours / 24.0;

    return userWord.copyWith(
      repetitionCount: repetitionCount,
      wrongCount: wrongCount,
      stage: stage,
      lastReviewed: now,
      nextReview: nextReview,
      interval: interval,
      easeFactor: 2.5, // Reset to standard ease factor for now
    );
  }

  Future<void> _onNextRequested(
    ReviewWordNextRequested event,
    Emitter<ReviewWordState> emit,
  ) async {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.reviewWords.length) {
      emit(state.copyWith(status: ReviewWordStatus.finished));
      // Silent refresh to update count for other pages (Home/WordPage)
      if (state.reviewWords.isNotEmpty) {
        add(ReviewWordRefreshed(userId: state.reviewWords.first.userId));
      }
    } else {
      emit(
        state.copyWith(
          status: ReviewWordStatus.loading,
          currentIndex: nextIndex,
        ),
      );
      await _loadCurrentWordDetails(emit);
    }
  }

  void _onFinishedRequested(
    ReviewWordFinishedRequested event,
    Emitter<ReviewWordState> emit,
  ) {
    emit(
      state.copyWith(status: ReviewWordStatus.finished, isShowingAnswer: false),
    );
  }
}
