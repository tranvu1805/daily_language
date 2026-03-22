part of 'words_bloc.dart';

sealed class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

final class WordsRequested extends WordsEvent {
  final GetDictionaryWordsUseCaseParams param;

  const WordsRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class WordsLoadMore extends WordsEvent {
  final GetDictionaryWordsUseCaseParams param;

  const WordsLoadMore({required this.param});

  @override
  List<Object> get props => [param];
}
