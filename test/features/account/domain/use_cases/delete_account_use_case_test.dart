import 'package:daily_language/features/account/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepos extends Mock implements AccountRepos {}

void main() {
  late AccountRepos repository;
  late DeleteAccountUseCase useCase;

  const tId = '1';

  setUp(() {
    repository = MockAccountRepos();
    useCase = DeleteAccountUseCase(repository);
  });

  test('should call [AccountRepos.deleteAccount]', () async {
    // arrange
    when(
          () => repository.deleteAccount(id: any(named: 'id')),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await useCase(tId);
    // assert
    expect(result, equals(const Right(null)));
    verify(() => repository.deleteAccount(id: tId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
