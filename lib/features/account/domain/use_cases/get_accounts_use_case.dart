import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';

class GetAccountsUseCase
    implements UseCaseWithParams<List<Account>, int> {
  final AccountRepos _repository;

  const GetAccountsUseCase(this._repository);

  @override
  ResultFuture<List<Account>> call(int page) async =>
      await _repository.getAccounts(page: page);
}
