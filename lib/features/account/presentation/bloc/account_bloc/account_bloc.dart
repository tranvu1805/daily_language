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
    on<AccountStreakUpdated>(_onStreakUpdated);
  }

  Future<void> _onAccountRequested(
    AccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());
    final result = await _getAccountUseCase(event.uid);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (
      account,
    ) {
      // Check for streak reset if they missed consecutive days
      final checkedAccount = _checkStreakReset(account);
      if (checkedAccount != account) {
        // If reset happened, persist it immediately
        add(
          AccountUpdated(
            param: UpdateAccountUseCaseParams(
              uid: account.uid,
              fullName: account.fullName,
              phoneNumber: account.phoneNumber,
              streak: checkedAccount.streak,
            ),
          ),
        );
      }
      emit(AccountSuccess(account: checkedAccount));
    });
  }

  Future<void> _onStreakUpdated(
    AccountStreakUpdated event,
    Emitter<AccountState> emit,
  ) async {
    final account = event.account;
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);

    int newStreak = account.streak;
    int newMaxStreak = account.maxStreak;
    DateTime? lastActivity = account.lastActivityAt;

    if (lastActivity == null) {
      newStreak = 1;
    } else {
      final lastDate = DateTime(
        lastActivity.year,
        lastActivity.month,
        lastActivity.day,
      );
      final daysDiff = nowDate.difference(lastDate).inDays;

      if (daysDiff == 0) {
        // Already updated today, skip
        return;
      } else if (daysDiff == 1) {
        // Consecutive days increase streak
        newStreak++;
      } else {
        // Streak broken, reset to 1 (counting today)
        newStreak = 1;
      }
    }

    if (newStreak > newMaxStreak) {
      newMaxStreak = newStreak;
    }

    // Persist to firestore
    add(
      AccountUpdated(
        param: UpdateAccountUseCaseParams(
          uid: account.uid,
          fullName: account.fullName,
          phoneNumber: account.phoneNumber,
          streak: newStreak,
          maxStreak: newMaxStreak,
          lastActivityAt: now,
        ),
      ),
    );
  }

  Account _checkStreakReset(Account account) {
    if (account.lastActivityAt == null) return account;
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      account.lastActivityAt!.year,
      account.lastActivityAt!.month,
      account.lastActivityAt!.day,
    );
    final diff = nowDate.difference(lastDate).inDays;
    if (diff > 1) {
      // Missed at least one whole day, streak reset to 0
      return Account(
        uid: account.uid,
        fullName: account.fullName,
        email: account.email,
        phoneNumber: account.phoneNumber,
        streak: 0,
        maxStreak: account.maxStreak,
        lastActivityAt: account.lastActivityAt,
        avatarUrl: account.avatarUrl,
      );
    }
    return account;
  }

  Future<void> _onCreated(
    AccountCreated event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());
    final result = await _createAccountUseCase(event.param);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountCreateSuccess());
      add(AccountRequested(uid: event.param.uid));
    });
  }

  Future<void> _onUpdated(
    AccountUpdated event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());
    final result = await _updateAccountUseCase(event.param);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountUpdateSuccess());
      add(AccountRequested(uid: event.param.uid));
    });
  }

  Future<void> _onDeleted(
    AccountDeleted event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());
    final result = await _deleteAccountUseCase(event.id);
    result.fold((failure) => emit(AccountFailure(error: failure.message)), (_) {
      emit(AccountDeleteSuccess());
    });
  }
}
