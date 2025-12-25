import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/authentication/data/data.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';

class AuthenticationReposImpl implements AuthenticationRepos {
  final AuthenticationRemoteDataSource _remoteDataSource;

  AuthenticationReposImpl({required AuthenticationRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Stream<User?> getUser() {
    return _remoteDataSource.getUser().map((UserModel? model) => model?.toEntity());
  }

  @override
  ResultVoid loginWithGoogle() {
    return ApiService.handle(() async {
      await _remoteDataSource.loginWithGoogle();
    });
  }

  @override
  ResultVoid logout() {
    return ApiService.handle(() async {
      await _remoteDataSource.logout();
    });
  }
}
