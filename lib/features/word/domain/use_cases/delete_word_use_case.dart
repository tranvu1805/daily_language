import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';

class DeleteWordUseCase implements UseCaseWithParams<void, String> {
  final WordRepos _repository;

  const DeleteWordUseCase(this._repository);

  @override
  ResultVoid call(String params) async =>
      await _repository.deleteWord(id: params);
}
