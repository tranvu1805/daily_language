import 'package:daily_language/features/authentication/domain/domain.dart';

class GetUserUseCase {
  const GetUserUseCase(this._repository);

  final AuthenticationRepos _repository;

  Stream<User?> call() => _repository.getUser();
}
