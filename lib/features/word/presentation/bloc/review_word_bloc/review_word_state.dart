part of 'review_word_bloc.dart';

enum ReviewWordStatus { initial, loading, loaded, finished, failure }

class ReviewWordState extends Equatable {
  final ReviewWordStatus status;
  final List<UserWord> reviewWords;
  final int currentIndex;
  final Word? currentDictionaryWord;
  final bool isShowingAnswer;
  final bool isCorrect;
  final String error;

  const ReviewWordState({
    this.status = ReviewWordStatus.initial,
    this.reviewWords = const [],
    this.currentIndex = 0,
    this.currentDictionaryWord,
    this.isShowingAnswer = false,
    this.isCorrect = false,
    this.error = '',
  });

  ReviewWordState copyWith({
    ReviewWordStatus? status,
    List<UserWord>? reviewWords,
    int? currentIndex,
    Word? currentDictionaryWord,
    bool? isShowingAnswer,
    bool? isCorrect,
    String? error,
  }) {
    return ReviewWordState(
      status: status ?? this.status,
      reviewWords: reviewWords ?? this.reviewWords,
      currentIndex: currentIndex ?? this.currentIndex,
      currentDictionaryWord: currentDictionaryWord ?? this.currentDictionaryWord,
      isShowingAnswer: isShowingAnswer ?? this.isShowingAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviewWords,
    currentIndex,
    currentDictionaryWord,
    isShowingAnswer,
    isCorrect,
    error,
  ];
}
