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
  })  : _getUserWordsUseCase = getUserWordsUseCase,
        _getDictionaryWordByIdUseCase = getDictionaryWordByIdUseCase,
        _updateUserWordUseCase = updateUserWordUseCase,
        super(const ReviewWordState()) {
    on<ReviewWordLoaded>(_onReviewWordLoaded);
    on<ReviewWordAnswerSubmitted>(_onAnswerSubmitted);
    on<ReviewWordNextRequested>(_onNextRequested);
    on<ReviewWordFinishedRequested>(_onFinishedRequested);
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

        emit(
          state.copyWith(
            reviewWords: reviewWords,
            currentIndex: 0,
          ),
        );

        await _loadCurrentWordDetails(emit);
      },
    );
  }

  Future<void> _loadCurrentWordDetails(Emitter<ReviewWordState> emit) async {
    final userWord = state.reviewWords[state.currentIndex];

    // UserWord only contains the word string, we need details like meanings.
    final result = await _getDictionaryWordByIdUseCase(
      GetDictionaryWordByIdUseCaseParams(id: userWord.wordId),
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

    final correctAnswer = state.currentDictionaryWord!.content.trim().toLowerCase();
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
    num easeFactor = userWord.easeFactor;
    num interval = userWord.interval;

    if (isCorrect) {
      repetitionCount++;
      stage++;

      // SM-2 like interval calculation
      if (repetitionCount == 1) {
        interval = 1;
      } else if (repetitionCount == 2) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }

      // Slightly increase ease factor for correct answers
      easeFactor = easeFactor + 0.1;
    } else {
      wrongCount++;
      // If wrong, reset or decrease stage
      stage = 0;
      repetitionCount = 0;
      interval = 1; // Review again tomorrow (or in a few minutes in a real app)
      
      // Decrease ease factor
      easeFactor = (easeFactor - 0.2).clamp(1.3, 2.5);
    }

    // Cap values if needed (Mochi has 5-7 stages usually)
    // For now, keep it simple.
    
    // Mochi style durations often increase exponentially based on stage.
    // Stage 1: 1m, 2: 12m, 3: 1d, 4: 4d, 5: 9d, etc.
    // For simplicity, we use day-based calculation here as SM-2.
    
    DateTime nextReview;
    if (isCorrect) {
        nextReview = now.add(Duration(days: interval.toInt()));
    } else {
        // Review again in 10 minutes if wrong
        nextReview = now.add(const Duration(minutes: 10));
    }

    return userWord.copyWith(
      repetitionCount: repetitionCount,
      wrongCount: wrongCount,
      stage: stage,
      lastReviewed: now,
      nextReview: nextReview,
      easeFactor: easeFactor,
      interval: interval,
    );
  }

  Future<void> _onNextRequested(
    ReviewWordNextRequested event,
    Emitter<ReviewWordState> emit,
  ) async {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.reviewWords.length) {
      emit(state.copyWith(status: ReviewWordStatus.finished));
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
    emit(state.copyWith(status: ReviewWordStatus.finished));
  }
}
