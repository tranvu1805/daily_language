import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepos extends Mock implements AccountRepos {}

void main() {
  late AccountRepos repository;
  late GetAccountUseCase useCase;

  const tId = '1';
  final tAccount = Account.empty();

  setUp(() {
    repository = MockAccountRepos();
    useCase = GetAccountUseCase(repository);
  });

  test('should call [AccountRepos.getAccount]', () async {
    // arrange
    when(
      () => repository.getAccount(uid: any(named: 'id')),
    ).thenAnswer((_) async => Right(tAccount));
    // act
    final result = await useCase(tId);
    // assert
    expect(result, equals(Right(tAccount)));
    verify(() => repository.getAccount(uid: tId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
