part of 'words_bloc.dart';

enum WordsStatus { initial, loading, success, failure }

enum WordsAction { none, request, refresh }

final class WordsState extends Equatable {
  const WordsState({
    this.words = const [],
    this.status = WordsStatus.initial,
    this.hasReachedMax = false,
    this.lastDocId,
    this.action = WordsAction.none,
    this.error = '',
  });

  final List<Word> words;
  final WordsAction action;
  final String error;
  final bool hasReachedMax;
  final String? lastDocId;
  final WordsStatus status;

  WordsState copyWith({
    List<Word>? words,
    WordsStatus? status,
    bool? hasReachedMax,
    String? lastDocId,
    WordsAction? action,
    String? error,
  }) {
    return WordsState(
      words: words ?? this.words,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocId: lastDocId ?? this.lastDocId,
      action: action ?? this.action,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    words,
    status,
    hasReachedMax,
    lastDocId,
    action,
    error,
  ];
}
