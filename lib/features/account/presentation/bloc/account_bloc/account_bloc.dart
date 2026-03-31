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
    on<AccountLoggedIn>(_onAccountLoggedIn);
    on<AccountUpdated>(_onUpdated);
    on<AccountDeleted>(_onDeleted);
    on<AccountStreakUpdated>(_onStreakUpdated);
    on<AccountAiReviewUsed>(_onAiReviewUsed);
    on<AccountAiReviewRewardEarned>(_onAiReviewRewardEarned);
  }

  Future<void> _onAccountRequested(
    AccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());
    final result = await _getAccountUseCase(event.uid);
    result.fold(
      (failure) {
        emit(AccountFailure(error: failure.message));
      },
      (account) {
        // Check for streak reset if they missed consecutive days
        final checkedAccount = _checkStreakReset(account);
        emit(AccountSuccess(account: checkedAccount));
      },
    );
  }

  Account _checkStreakReset(Account account) {
    final now = DateTime.now().toLocal();
    final nowDate = DateTime(now.year, now.month, now.day);
    if (account.lastActivityAt == null) {
      return account;
    }
    final lastDate = DateTime(
      account.lastActivityAt!.year,
      account.lastActivityAt!.month,
      account.lastActivityAt!.day,
    );
    final diff = nowDate.difference(lastDate).inDays;
    if (diff > 1) {
      // Missed at least one whole day, streak reset to 0
      return account.copyWith(streak: 0);
    }
    return account;
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

  Future<void> _onAiReviewUsed(
    AccountAiReviewUsed event,
    Emitter<AccountState> emit,
  ) async {
    final account = event.account;
    final now = DateTime.now().toLocal();
    final lastReview = account.lastAiReviewAt?.toLocal();
    final isNewDay =
        lastReview == null ||
        lastReview.day != now.day ||
        lastReview.month != now.month ||
        lastReview.year != now.year;

    int newCount = isNewDay ? 1 : account.aiReviewCount + 1;
    int newCoins = account.aiReviewCoins;

    if (newCount > 3) {
      if (newCoins > 0) {
        newCoins--;
      } else {
        // This should be handled in UI, but safety check
        return;
      }
    }

    add(
      AccountUpdated(
        param: UpdateAccountUseCaseParams(
          uid: account.uid,
          fullName: account.fullName,
          phoneNumber: account.phoneNumber,
          aiReviewCount: newCount,
          aiReviewCoins: newCoins,
          lastAiReviewAt: now,
        ),
      ),
    );
  }

  Future<void> _onAiReviewRewardEarned(
    AccountAiReviewRewardEarned event,
    Emitter<AccountState> emit,
  ) async {
    final account = event.account;
    add(
      AccountUpdated(
        param: UpdateAccountUseCaseParams(
          uid: account.uid,
          fullName: account.fullName,
          phoneNumber: account.phoneNumber,
          aiReviewCoins: account.aiReviewCoins + 1,
        ),
      ),
    );
  }

  Future<void> _onAccountLoggedIn(
    AccountLoggedIn event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountInProgress());

    final result = await _getAccountUseCase(event.param.uid);
    await result.fold(
      (failure) async {
        if (failure.message == 'dataNotFound' && failure.statusCode == 404) {
          final createResult = await _createAccountUseCase(event.param);
          createResult.fold(
            (f) => emit(AccountFailure(error: f.message)),
            (_) => add(AccountRequested(uid: event.param.uid)),
          );
        } else {
          emit(AccountFailure(error: failure.message));
        }
      },
      (account) {
        final checkedAccount = _checkStreakReset(account);
        emit(AccountSuccess(account: checkedAccount));
      },
    );
  }
}
