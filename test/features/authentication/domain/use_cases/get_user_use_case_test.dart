import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepos extends Mock implements AuthenticationRepos {}

void main() {
  late AuthenticationRepos repository;
  late GetUserUseCase useCase;

  const tAuthentication = User.empty();

  setUp(() {
    repository = MockAuthenticationRepos();
    useCase = GetUserUseCase(repository);
  });

  test('should call [AuthenticationRepos.getAuthentication]', () async {
    // arrange
    when(() => repository.getUser()).thenAnswer((_) => Stream.value(tAuthentication));
    // act
    final result = useCase();
    // assert
    expect(result, isA<Stream<User?>>());
    verify(() => repository.getUser()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
