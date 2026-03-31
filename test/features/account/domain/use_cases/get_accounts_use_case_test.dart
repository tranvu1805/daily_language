import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepos extends Mock implements AccountRepos {}

void main() {
  late AccountRepos repository;
  late GetAccountsUseCase useCase;

  const tPage = 1;
  final tAccounts = [Account.empty()];

  setUp(() {
    repository = MockAccountRepos();
    useCase = GetAccountsUseCase(repository);
  });

  test('should call [AccountRepos.getAccounts]', () async {
    // arrange
    when(
      () => repository.getAccounts(page: any(named: 'page')),
    ).thenAnswer((_) async => Right(tAccounts));
    // act
    final result = await useCase(tPage);
    // assert
    expect(result, equals(Right(tAccounts)));
    verify(() => repository.getAccounts(page: tPage)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
