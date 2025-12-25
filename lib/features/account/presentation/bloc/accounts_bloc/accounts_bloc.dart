import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/features/account/domain/domain.dart';


part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetAccountsUseCase _getAccountsUseCase;

  AccountsBloc({required GetAccountsUseCase getAccountsUseCase,})
    : _getAccountsUseCase = getAccountsUseCase,
       super(const AccountsState()) {
    on<AccountsRequested>(_onRequested);
    on<AccountsRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(AccountsRequested event,
    Emitter<AccountsState> emit,
  ) async {
    if (state.hasReachedMax || state.status == AccountsStatus.loading) return;
    if (state.currentPage == 1) {
      emit(state.copyWith(status: AccountsStatus.loading));
    }
    final result = await _getAccountsUseCase(state.currentPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountsStatus.failure,
          error: failure.message,
          action: 'requested',
        ),
      ),
      (accounts) => emit(
        state.copyWith(
          status: AccountsStatus.success,
          accounts: [...state.accounts, ...accounts],
          currentPage: state.currentPage + 1,
          hasReachedMax: accounts.length < pageSize,
          action: 'requested',
        ),
      ),
    );
  }

  Future<void> _onRefreshed(AccountsRefreshed event, Emitter<AccountsState> emit,
  ) async {
    emit(const AccountsState());
    add(AccountsRequested());
  }
}
