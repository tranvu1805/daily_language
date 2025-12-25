import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

void main() {
  late GetAccountsUseCase getAccountsUseCase;
  late AccountsBloc account;
  const tFailure = ServerFailure(message: 'error', statusCode: 555);

  setUp(() {
    getAccountsUseCase = MockGetAccountsUseCase();
    account = AccountsBloc(
      getAccountsUseCase: getAccountsUseCase,
    );
  });

  group('AccountsRequested', () {
    blocTest(
      'should emit AccountsSuccess when successfully',
      build: () => account,
      setUp: () {
        when(() => getAccountsUseCase(any())).thenAnswer((_) async => const Right(<Account>[]));
      },
      act: (bloc) => bloc.add(AccountsRequested()),
      expect: () => [
        const AccountsState(status: AccountsStatus.loading),
        const AccountsState(
          accounts: [],
          status: AccountsStatus.success,
          action: 'requested',
          currentPage: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest(
      'should emit AccountsFailure when unsuccessfully',
      build: () => account,
      setUp: () {
        when(() => getAccountsUseCase(any())).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(AccountsRequested()),
      expect: () => [
        const AccountsState(status: AccountsStatus.loading),
    AccountsState(
          error: tFailure.message,
          status: AccountsStatus.failure,
          action: 'requested',
        ),
      ],
    );
  });

  group('AccountsRefreshed', () {
    blocTest(
      'should emit AccountsSuccess when successfully',
      build: () => account,
      setUp: () {
        when(() => getAccountsUseCase(any())).thenAnswer((_) async => const Right(<Account>[]));
      },
      act: (bloc) => bloc.add(AccountsRefreshed()),
      expect: () => [
        const AccountsState(status: AccountsStatus.initial),
        const AccountsState(status: AccountsStatus.loading),
        const AccountsState(
          accounts: [],
          status: AccountsStatus.success,
          action: 'requested',
          currentPage: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest(
      'should emit AccountsFailure when unsuccessfully',
      build: () => account,
      setUp: () {
        when(() => getAccountsUseCase(any())).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(AccountsRefreshed()),
      expect: () => [
        const AccountsState(status: AccountsStatus.initial),
        const AccountsState(status: AccountsStatus.loading),
    AccountsState(
          error: tFailure.message,
          status: AccountsStatus.failure,
          action: 'requested',
        ),
      ],
    );
  });

}
