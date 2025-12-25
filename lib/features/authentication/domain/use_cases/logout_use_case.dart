import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';

class LogoutUseCase implements UseCase<void> {
  const LogoutUseCase(this._repository);

  final AuthenticationRepos _repository;

  @override
  ResultVoid call() => _repository.logout();
}
