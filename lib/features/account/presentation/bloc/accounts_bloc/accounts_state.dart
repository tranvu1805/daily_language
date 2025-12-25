part of 'accounts_bloc.dart';

enum AccountsStatus { initial, loading, success, failure }

final class AccountsState extends Equatable {
  const AccountsState({
    this.accounts = const [],
    this.status = AccountsStatus.initial,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.action = '',
    this.error = '',
  });

  final List<Account> accounts;
  final String action;
  final String error;
  final bool hasReachedMax;
  final int currentPage;
  final AccountsStatus status;

  AccountsState copyWith({
    List<Account>? accounts,
    AccountsStatus? status,
    bool? hasReachedMax,
    int? currentPage,
    String? action,
    String? error,
  }) {
    return AccountsState(
      accounts: accounts ?? this.accounts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      action: action ?? this.action,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [accounts, status, hasReachedMax, currentPage, action, error];
}
