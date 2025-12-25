import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/data/data.dart';
import 'package:daily_language/features/account/domain/domain.dart';

class AccountReposImpl implements AccountRepos {
  final AccountRemoteDataSource _remoteDataSource;

  AccountReposImpl({required AccountRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<Account>> getAccounts({required int page}) async {
    throw UnimplementedError();
    // return ApiService.handle(() async {
    //   final models = await _remoteDataSource.getAccounts(token: token, page: page);
    //   return models.map<Account>((model) => model.toEntity()).toList();
    // });
  }

  @override
  ResultVoid createAccount({required CreateAccountUseCaseParams params}) {
    return ApiService.handle(() async {
      final accountModel = AccountModel.toCreate(
        uid: params.uid,
        email: params.email,
        fullName: params.fullName,
      );
      await _remoteDataSource.createAccount(account: accountModel);
    });
  }

  @override
  ResultVoid updateAccount({required UpdateAccountUseCaseParams params}) {
    throw UnimplementedError();
    // return ApiService.handle(() async {
    //   final model = AccountModel.toUpdate();
    //   final token = await _authLocalDataSource.getToken();
    //   await _remoteDataSource.updateAccount(account: model, token: token);
    // });
  }

  @override
  ResultVoid deleteAccount({required String id}) {
    throw UnimplementedError();
    // return ApiService.handle(() async {
    //   final token = await _authLocalDataSource.getToken();
    //   await _remoteDataSource.deleteAccount(id: id, token: token);
    // });
  }

  @override
  ResultFuture<Account> getAccount({required String uid}) async {
    return ApiService.handle(() async {
      final model = await _remoteDataSource.getAccount(uid: uid);
      return model.toEntity();
    });
  }
}
