part of 'word_bloc.dart';

sealed class WordEvent extends Equatable {
  const WordEvent();
  @override
  List<Object> get props => [];
}

final class WordRequested extends WordEvent {
  final GetWordUseCaseParams param;

  const WordRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class WordCreated extends WordEvent {
  final CreateWordUseCaseParams param;

  const WordCreated({required this.param});

  @override
  List<Object> get props => [param];
}

final class WordUpdated extends WordEvent {
  final UpdateWordUseCaseParams param;

  const WordUpdated({required this.param});

  @override
  List<Object> get props => [param];
}

final class WordDeleted extends WordEvent {
  final String id;

  const WordDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
