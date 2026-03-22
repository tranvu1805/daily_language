part of 'user_word_bloc.dart';

sealed class UserWordEvent extends Equatable {
  const UserWordEvent();
  @override
  List<Object> get props => [];
}

final class UserWordRequested extends UserWordEvent {
  final GetUserWordUseCaseParams param;

  const UserWordRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class UserWordCreated extends UserWordEvent {
  final CreateUserWordUseCaseParams param;

  const UserWordCreated({required this.param});

  @override
  List<Object> get props => [param];
}

final class UserWordUpdated extends UserWordEvent {
  final UpdateUserWordUseCaseParams param;

  const UserWordUpdated({required this.param});

  @override
  List<Object> get props => [param];
}

final class UserWordDeleted extends UserWordEvent {
  final DeleteUserWordUseCaseParams param;

  const UserWordDeleted({required this.param});

  @override
  List<Object> get props => [param];
}
