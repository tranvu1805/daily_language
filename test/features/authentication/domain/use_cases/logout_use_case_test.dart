import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepos extends Mock implements AuthenticationRepos {}

void main() {
  late AuthenticationRepos repository;
  late LogoutUseCase useCase;

  setUp(() {
    repository = MockAuthenticationRepos();
    useCase = LogoutUseCase(repository);
  });

  test('should call [AuthenticationRepos.getAuthentication]', () async {
    // arrange
    when(() => repository.logout()).thenAnswer((_) async => Right(null));
    // act
    final result = await useCase();
    // assert
    expect(result, equals(Right(null)));
    verify(() => repository.logout()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
