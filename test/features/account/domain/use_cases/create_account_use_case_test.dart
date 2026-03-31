import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepos extends Mock implements AccountRepos {}

void main() {
  late AccountRepos repository;
  late CreateAccountUseCase useCase;

  const tParams = CreateAccountUseCaseParams.empty();

  setUp(() {
    repository = MockAccountRepos();
    useCase = CreateAccountUseCase(repository);
    registerFallbackValue(tParams);
  });

  test('should call [AccountRepos.createAccount]', () async {
    // arrange
    when(
      () => repository.createAccount(params: any(named: 'params')),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await useCase(tParams);
    // assert
    expect(result, equals(const Right(null)));
    verify(() => repository.createAccount(params: tParams)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
