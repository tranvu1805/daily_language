import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRemoteDataSource extends Mock
    implements AccountRemoteDataSource {}

void main() {
  late MockAccountRemoteDataSource mockRemoteDataSource;
  late AccountReposImpl repository;
  const tId = 'id';
  const tException = ServerException(message: 'Unknown error', statusCode: 555);
  final tCreateAccountUseCaseParams = const CreateAccountUseCaseParams.empty();
  final tCreateAccountModel = AccountModel.toCreate(
    avatarUrl: tCreateAccountUseCaseParams.avatarUrl,
    uid: tCreateAccountUseCaseParams.uid,
    email: tCreateAccountUseCaseParams.email,
    fullName: tCreateAccountUseCaseParams.fullName,
    lastActivityAt: null,
  );
  final tUpdateAccountModel = const AccountModel();

  setUp(() {
    mockRemoteDataSource = MockAccountRemoteDataSource();
    repository = AccountReposImpl(remoteDataSource: mockRemoteDataSource);
    registerFallbackValue(tCreateAccountModel);
    registerFallbackValue(tUpdateAccountModel);
  });

  // group('getAccounts', () {
  //   test('should call getAccounts and return list of accounts when successfully', () async {
  //     when(
  //       () => mockRemoteDataSource.getAccounts(
  //         page: any(named: 'page'),
  //         token: any(named: 'token'),
  //       ),
  //     ).thenAnswer((_) async => const [AccountModel.empty()]);
  //
  //     final result = await repository.getAccounts(page: tPage);
  //
  //     result.fold((_) {}, (list) => expect(result, equals(Right(list))));
  //     verify(() => mockRemoteDataSource.getAccounts(page: tPage, token: tToken)).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  //
  //   test('should call getAccounts and return exception when unsuccessfully', () async {
  //     when(
  //       () => mockRemoteDataSource.getAccounts(
  //         page: any(named: 'page'),
  //         token: any(named: 'token'),
  //       ),
  //     ).thenThrow(tException);
  //
  //     final result = await repository.getAccounts(page: tPage);
  //
  //     expect(result, equals(Left(ServerFailure.fromException(tException))));
  //     verify(() => mockRemoteDataSource.getAccounts(page: tPage, token: tToken)).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  // });

  group('getAccount', () {
    test(
      'should call getAccount and return account when successfully',
      () async {
        when(
          () => mockRemoteDataSource.getAccount(uid: any(named: 'uid')),
        ).thenAnswer((_) async => const AccountModel.empty());

        final result = await repository.getAccount(uid: tId);

        expect(result, equals(Right(Account.empty())));
        verify(() => mockRemoteDataSource.getAccount(uid: tId)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should call getAccount and return exception when unsuccessfully',
      () async {
        when(
          () => mockRemoteDataSource.getAccount(uid: any(named: 'uid')),
        ).thenThrow(tException);

        final result = await repository.getAccount(uid: tId);

        expect(result, equals(Left(ServerFailure.fromException(tException))));
        verify(() => mockRemoteDataSource.getAccount(uid: tId)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('createAccount', () {
    test('should call createAccount when successfully', () async {
      when(
        () =>
            mockRemoteDataSource.createAccount(account: any(named: 'account')),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.createAccount(
        params: tCreateAccountUseCaseParams,
      );

      expect(result, equals(const Right(null)));
      verify(
        () => mockRemoteDataSource.createAccount(account: tCreateAccountModel),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
      'should call createAccount and return exception when unsuccessfully',
      () async {
        when(
          () => mockRemoteDataSource.createAccount(
            account: any(named: 'account'),
          ),
        ).thenThrow(tException);

        final result = await repository.createAccount(
          params: tCreateAccountUseCaseParams,
        );

        expect(result, equals(Left(ServerFailure.fromException(tException))));
        verify(
          () =>
              mockRemoteDataSource.createAccount(account: tCreateAccountModel),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
  //
  // group('updateAccount', () {
  //   test('should call updateAccount when successfully', () async {
  //     when(
  //       () => mockRemoteDataSource.updateAccount(
  //         account: any(named: 'account'),
  //         token: any(named: 'token'),
  //       ),
  //     ).thenAnswer((_) async => Future.value());
  //
  //     final result = await repository.updateAccount(params: tUpdateAccountUseCaseParams);
  //
  //     expect(result, equals(const Right(null)));
  //     verify(
  //       () => mockRemoteDataSource.updateAccount(token: tToken, account: tUpdateAccountModel),
  //     ).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  //
  //   test('should call updateAccount and return exception when unsuccessfully', () async {
  //     when(
  //       () => mockRemoteDataSource.updateAccount(
  //         token: any(named: 'token'),
  //         account: any(named: 'account'),
  //       ),
  //     ).thenThrow(tException);
  //
  //     final result = await repository.updateAccount(params: tUpdateAccountUseCaseParams);
  //
  //     expect(result, equals(Left(ServerFailure.fromException(tException))));
  //     verify(
  //       () => mockRemoteDataSource.updateAccount(token: tToken, account: tUpdateAccountModel),
  //     ).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  // });
  //
  // group('deleteAccount', () {
  //   test('should call deleteAccount when successfully', () async {
  //     when(
  //       () => mockRemoteDataSource.deleteAccount(
  //         id: any(named: 'id'),
  //         token: any(named: 'token'),
  //       ),
  //     ).thenAnswer((_) async => Future.value());
  //
  //     final result = await repository.deleteAccount(id: tId);
  //
  //     expect(result, equals(const Right(null)));
  //     verify(() => mockRemoteDataSource.deleteAccount(id: tId, token: tToken)).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  //
  //   test('should call deleteAccount and return exception when unsuccessfully', () async {
  //     when(
  //       () => mockRemoteDataSource.deleteAccount(
  //         id: any(named: 'id'),
  //         token: any(named: 'token'),
  //       ),
  //     ).thenThrow(tException);
  //
  //     final result = await repository.deleteAccount(id: tId);
  //
  //     expect(result, equals(Left(ServerFailure.fromException(tException))));
  //     verify(() => mockRemoteDataSource.deleteAccount(id: tId, token: tToken)).called(1);
  //     verifyNoMoreInteractions(mockRemoteDataSource);
  //   });
  // });
}
