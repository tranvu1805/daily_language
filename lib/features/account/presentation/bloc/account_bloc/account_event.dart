part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();
  @override
  List<Object> get props => [];
}

final class AccountRequested extends AccountEvent {
  final String uid;

  const AccountRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}

final class AccountLoggedIn extends AccountEvent {
  final CreateAccountUseCaseParams param;

  const AccountLoggedIn({required this.param});

  @override
  List<Object> get props => [param];
}

final class AccountUpdated extends AccountEvent {
  final UpdateAccountUseCaseParams param;

  const AccountUpdated({required this.param});

  @override
  List<Object> get props => [param];
}

final class AccountDeleted extends AccountEvent {
  final String id;

  const AccountDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

final class AccountStreakUpdated extends AccountEvent {
  final Account account;

  const AccountStreakUpdated({required this.account});

  @override
  List<Object> get props => [account];
}

final class AccountAiReviewUsed extends AccountEvent {
  final Account account;

  const AccountAiReviewUsed({required this.account});

  @override
  List<Object> get props => [account];
}

final class AccountAiReviewRewardEarned extends AccountEvent {
  final Account account;

  const AccountAiReviewRewardEarned({required this.account});

  @override
  List<Object> get props => [account];
}
