import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepos extends Mock implements AccountRepos {}

void main() {
  late AccountRepos repository;
  late UpdateAccountUseCase useCase;

  const tParams = UpdateAccountUseCaseParams.empty();

  setUp(() {
    repository = MockAccountRepos();
    useCase = UpdateAccountUseCase(repository);
    registerFallbackValue(tParams);
  });

  test('should call [AccountRepos.updateAccount]', () async {
    // arrange
    when(
          () => repository.updateAccount(params: any(named: 'params')),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await useCase(tParams);
    // assert
    expect(result, equals(const Right(null)));
    verify(() => repository.updateAccount(params: tParams)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
