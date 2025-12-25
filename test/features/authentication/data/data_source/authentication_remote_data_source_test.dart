import 'package:daily_language/core/errors/exceptions.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRemoteDataSource extends Mock implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource dataSource;
  const tException = ServerException(message: 'Unknown error', statusCode: 555);

  setUp(() {
    dataSource = MockAuthenticationRemoteDataSource();
  });
  group('getAuthentication', () {
    test('should call getAuthentication and return a user when successfully', () async {
      // arrange
      when(() => dataSource.loginWithGoogle()).thenAnswer((_) async => Future.value());
      // act
      final response = dataSource.loginWithGoogle();
      // assert
      expect(response, completes);
      verify(() => dataSource.loginWithGoogle()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('should call getAuthentication and throw exception when unsuccessfully', () async {
      // arrange
      when(() => dataSource.loginWithGoogle()).thenThrow(tException);
      // act & assert
      await expectLater(() => dataSource.loginWithGoogle(), throwsA(tException));
      verify(() => dataSource.loginWithGoogle()).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
