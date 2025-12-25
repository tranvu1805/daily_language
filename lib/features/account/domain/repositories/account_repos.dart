import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';

abstract interface class AccountRepos {
  ResultFuture<List<Account>> getAccounts({required int page});

  ResultFuture<Account> getAccount({required String uid});

  ResultVoid createAccount({required CreateAccountUseCaseParams params});

  ResultVoid updateAccount({required UpdateAccountUseCaseParams params});

  ResultVoid deleteAccount({required String id});
}
