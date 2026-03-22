part of 'user_word_bloc.dart';

sealed class UserWordState extends Equatable {
  const UserWordState();

  @override
  List<Object> get props => [];
}

final class UserWordInitial extends UserWordState {}

final class UserWordInProgress extends UserWordState {}

final class UserWordCreateSuccess extends UserWordState {}

final class UserWordUpdateSuccess extends UserWordState {}

final class UserWordDeleteSuccess extends UserWordState {}

final class UserWordSuccess extends UserWordState {
  final UserWord userWord;

  const UserWordSuccess({required this.userWord});

  @override
  List<Object> get props => [userWord];
}

final class UserWordFailure extends UserWordState {
  final String error;

  const UserWordFailure({required this.error});

  @override
  List<Object> get props => [error];
}
