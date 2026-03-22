part of 'user_words_bloc.dart';

sealed class UserWordsEvent extends Equatable {
  const UserWordsEvent();

  @override
  List<Object> get props => [];
}

final class UserWordsRequested extends UserWordsEvent {
  final GetUserWordsUseCaseParams param;

  const UserWordsRequested({required this.param});

  @override
  List<Object> get props => [param];
}

final class UserWordsRefreshed extends UserWordsEvent {
  final GetUserWordsUseCaseParams param;

  const UserWordsRefreshed({required this.param});

  @override
  List<Object> get props => [param];
}
