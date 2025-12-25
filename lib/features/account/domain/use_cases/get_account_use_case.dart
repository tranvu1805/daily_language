import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';

class GetAccountUseCase implements UseCaseWithParams<Account, String> {
  const GetAccountUseCase(this._repository);

  final AccountRepos _repository;

  @override
  ResultFuture<Account> call(String id) => _repository.getAccount(uid: id);
}
