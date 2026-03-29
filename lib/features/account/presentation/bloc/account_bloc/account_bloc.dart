import 'dart:async';

import 'package:daily_language/features/account/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountUseCase _getAccountUseCase;
  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AccountBloc({
    required GetAccountUseCase getAccountUseCase,
    required CreateAccountUseCase createAccountUseCase,
    required UpdateAccountUseCase updateAccountUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  }) : _getAccountUseCase = getAccountUseCase,
       _createAccountUseCase = createAccountUseCase,
       _updateAccountUseCase = updateAccountUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       super(AccountInitial()) {
    on<AccountRequested>(_onAccountRequested);
    on<AccountCreated>(_onCreated);
    on<AccountUpdated>(_onUpdated);
    on<AccountDeleted>(_onDeleted);
  }

  Future<void> _onAccountRequested(AccountRequested event, Emitter<AccountState> emit) async {
    emit(AccountInProgress());
    final result = await _getAccountUseCase(event.uid);
    result.fold(
      (failure) => emit(AccountFailure(error: failure.message)),
      (account) => emit(AccountSuccess(account: account)),
    );
  }

  Future<void> _onCreated(AccountCreated event, Emitter<AccountState> emit) async {
    emit(AccountInProgress());
    final result = await _createAccountUseCase(event.param);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountCreateSuccess());
      add(AccountRequested(uid: event.param.uid));
    });
  }

  Future<void> _onUpdated(AccountUpdated event, Emitter<AccountState> emit) async {
    emit(AccountInProgress());
    final result = await _updateAccountUseCase(event.param);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountUpdateSuccess());
      add(AccountRequested(uid: event.param.uid));
    });
  }

  Future<void> _onDeleted(AccountDeleted event, Emitter<AccountState> emit) async {
    emit(AccountInProgress());
    final result = await _deleteAccountUseCase(event.id);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountDeleteSuccess());
    });
  }
}
