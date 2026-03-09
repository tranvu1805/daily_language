import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';

class DeleteRecordUseCase implements UseCaseWithParams<void, String> {
  final RecordRepos _repository;

  const DeleteRecordUseCase(this._repository);

  @override
  ResultVoid call(String params) async =>
      await _repository.deleteRecord(id: params);
}
