import 'package:bloc_test/bloc_test.dart';
import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateAccountUseCase extends Mock implements CreateAccountUseCase {}

class MockUpdateAccountUseCase extends Mock implements UpdateAccountUseCase {}

class MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

void main() {
  late CreateAccountUseCase createAccountUseCase;
  late UpdateAccountUseCase updateAccountUseCase;
  late GetAccountUseCase getAccountUseCase;
  late DeleteAccountUseCase deleteAccountUseCase;
  late AccountBloc accountBloc;
  const tFailure = ServerFailure(message: 'error', statusCode: 555);
  const tId = '1';
  const tCreateAccountParams = CreateAccountUseCaseParams.empty();
  const tUpdateAccountParams = UpdateAccountUseCaseParams.empty();

  setUp(() {
    createAccountUseCase = MockCreateAccountUseCase();
    updateAccountUseCase = MockUpdateAccountUseCase();
    getAccountUseCase = MockGetAccountUseCase();
    deleteAccountUseCase = MockDeleteAccountUseCase();
    accountBloc = AccountBloc(
      createAccountUseCase: createAccountUseCase,
      updateAccountUseCase: updateAccountUseCase,
      getAccountUseCase: getAccountUseCase,
      deleteAccountUseCase: deleteAccountUseCase,
    );
    registerFallbackValue(tCreateAccountParams);
    registerFallbackValue(tUpdateAccountParams);
  });

  group('AccountRequested', () {
    blocTest(
      'should emit AccountSuccess when successfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => getAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(Account.empty()));
      },
      act: (bloc) => bloc.add(const AccountRequested(uid: tId)),
      expect: () => [
        AccountInProgress(),
        const AccountSuccess(account: Account.empty()),
      ],
    );

    blocTest(
      'should emit AccountFailure when unsuccessfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => getAccountUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(const AccountRequested(uid: tId)),
      expect: () => [
        AccountInProgress(),
        AccountFailure(error: tFailure.message),
      ],
    );
  });

  group('AccountCreated', () {
    blocTest(
      'should emit AccountCreateSuccess when successfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => createAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(Account.empty()));
      },
      act: (bloc) =>
          bloc.add(const AccountCreated(param: tCreateAccountParams)),
      expect: () => [
        AccountInProgress(),
        AccountCreateSuccess(),
        AccountInProgress(),
        const AccountSuccess(account: Account.empty()),
      ],
    );

    blocTest(
      'should emit AccountFailure when unsuccessfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => createAccountUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) =>
          bloc.add(const AccountCreated(param: tCreateAccountParams)),
      expect: () => [
        AccountInProgress(),
        AccountFailure(error: tFailure.message),
      ],
    );
  });

  group('AccountUpdated', () {
    blocTest(
      'should emit AccountUpdateSuccess when successfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => updateAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(Account.empty()));
      },
      act: (bloc) =>
          bloc.add(const AccountUpdated(param: tUpdateAccountParams)),
      expect: () => [
        AccountInProgress(),
        AccountUpdateSuccess(),
        AccountInProgress(),
        const AccountSuccess(account: Account.empty()),
      ],
    );

    blocTest(
      'should emit AccountFailure when unsuccessfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => updateAccountUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) =>
          bloc.add(const AccountUpdated(param: tUpdateAccountParams)),
      expect: () => [
        AccountInProgress(),
        AccountFailure(error: tFailure.message),
      ],
    );
  });

  group('AccountDeleted', () {
    blocTest(
      'should emit AccountDeleteSuccess when successfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => deleteAccountUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(const AccountDeleted(id: tId)),
      expect: () => [AccountInProgress(), AccountDeleteSuccess()],
    );

    blocTest(
      'should emit AccountFailure when unsuccessfully',
      build: () => accountBloc,
      setUp: () {
        when(
          () => deleteAccountUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      act: (bloc) => bloc.add(const AccountDeleted(id: tId)),
      expect: () => [
        AccountInProgress(),
        AccountFailure(error: tFailure.message),
      ],
    );
  });
}
