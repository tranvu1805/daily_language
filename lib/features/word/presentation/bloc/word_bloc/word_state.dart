part of 'word_bloc.dart';

sealed class WordState extends Equatable {
  const WordState();

  @override
  List<Object> get props => [];
}

final class WordInitial extends WordState {}

final class WordInProgress extends WordState {}

final class WordCreateSuccess extends WordState {}

final class WordUpdateSuccess extends WordState {}

final class WordDeleteSuccess extends WordState {}

final class WordSuccess extends WordState {
  final Word word;

  const WordSuccess({required this.word});

  @override
  List<Object> get props => [word];
}

final class WordFailure extends WordState {
  final String error;

  const WordFailure({required this.error});

  @override
  List<Object> get props => [error];
}
