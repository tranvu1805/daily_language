part of 'words_bloc.dart';

sealed class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

final class WordsRequested extends WordsEvent {
  final GetWordsUseCaseParams param;

  const WordsRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class WordsRefreshed extends WordsEvent {
  final GetWordsUseCaseParams param;

  const WordsRefreshed({required this.param});

  @override
  List<Object> get props => [param];
}
