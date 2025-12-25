part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountInProgress extends AccountState {}

final class AccountCreateSuccess extends AccountState {}

final class AccountUpdateSuccess extends AccountState {}

final class AccountDeleteSuccess extends AccountState {}

final class AccountSuccess extends AccountState {
  final Account account;

  const AccountSuccess({required this.account});

  @override
  List<Object> get props => [account];
}

final class AccountFailure extends AccountState {
  final String error;

  const AccountFailure({required this.error});

  @override
  List<Object> get props => [error];
}
