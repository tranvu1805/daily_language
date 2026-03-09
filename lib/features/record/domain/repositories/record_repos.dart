import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';

abstract interface class RecordRepos {
  ResultFuture<List<Record>> getRecords({
    required GetRecordsUseCaseParams params,
  });

  ResultFuture<Record> getRecord({required GetRecordUseCaseParams params});

  ResultVoid createRecord({required CreateRecordUseCaseParams params});

  ResultVoid updateRecord({required UpdateRecordUseCaseParams params});

  ResultVoid deleteRecord({required String id});
}
