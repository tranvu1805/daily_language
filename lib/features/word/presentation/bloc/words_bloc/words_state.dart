part of 'words_bloc.dart';

enum WordStatus { initial, loading, success, failure }

enum WordAction { none, request, refresh }

final class WordsState extends Equatable {
  const WordsState({
    this.status = WordStatus.initial,
    this.error = '',
    this.words = const [],
    this.action = WordAction.none,
    this.hasReachedMax = false,
  });

  WordsState copyWith({
    WordStatus? status,
    String? error,
    List<Word>? words,
    WordAction? action,
    bool? hasReachedMax,
  }) {
    return WordsState(
      status: status ?? this.status,
      error: error ?? this.error,
      words: words ?? this.words,
      action: action ?? this.action,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  final WordStatus status;
  final String error;
  final List<Word> words;
  final WordAction action;
  final bool hasReachedMax;

  @override
  List<Object> get props => [status, error, words, action, hasReachedMax];
}
