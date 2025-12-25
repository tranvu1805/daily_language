import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/account/domain/domain.dart';

class DeleteAccountUseCase implements UseCaseWithParams<void, String> {
  final AccountRepos _repository;

  const DeleteAccountUseCase(this._repository);

  @override
  ResultVoid call(String params) async =>
      await _repository.deleteAccount(id: params);
}
