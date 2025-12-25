import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';

abstract interface class AuthenticationRepos {
  ResultVoid loginWithGoogle();

  Stream<User?> getUser();

  ResultVoid logout();
}
