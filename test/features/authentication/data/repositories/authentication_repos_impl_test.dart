import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/core/errors/failures.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRemoteDataSource extends Mock implements AuthenticationRemoteDataSource {}

void main() {
  late MockAuthenticationRemoteDataSource mockRemoteDataSource;
  late AuthenticationReposImpl repository;
  const tException = ServerException(message: 'Unknown error', statusCode: 555);
  // final tUpdateAuthenticationModel = AuthenticationModel();

  setUp(() {
    mockRemoteDataSource = MockAuthenticationRemoteDataSource();
    repository = AuthenticationReposImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('loginWithGoogle', () {
    test('should call loginWithGoogle and return authentication when successfully', () async {
      when(() => mockRemoteDataSource.loginWithGoogle()).thenAnswer((_) async => Future.value());

      final result = await repository.loginWithGoogle();

      expect(result, equals(const Right(null)));
      verify(() => mockRemoteDataSource.loginWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should call loginWithGoogle and return exception when unsuccessfully', () async {
      when(() => mockRemoteDataSource.loginWithGoogle()).thenThrow(tException);

      final result = await repository.loginWithGoogle();

      expect(result, equals(Left(ServerFailure.fromException(tException))));
      verify(() => mockRemoteDataSource.loginWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
  group('logout', () {
    test('should call logout and return authentication when successfully', () async {
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      expect(result, equals(const Right(null)));
      verify(() => mockRemoteDataSource.logout()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should call logout and return exception when unsuccessfully', () async {
      when(() => mockRemoteDataSource.logout()).thenThrow(tException);

      final result = await repository.logout();

      expect(result, equals(Left(ServerFailure.fromException(tException))));
      verify(() => mockRemoteDataSource.logout()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
