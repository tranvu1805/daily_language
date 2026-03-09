import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetRecordUseCase
    implements UseCaseWithParams<Record, GetRecordUseCaseParams> {
  const GetRecordUseCase(this._repository);

  final RecordRepos _repository;

  @override
  ResultFuture<Record> call(GetRecordUseCaseParams params) =>
      _repository.getRecord(params: params);
}

class GetRecordUseCaseParams extends Equatable {
  final String userId;
  final String id;

  const GetRecordUseCaseParams({required this.userId, required this.id});

  const GetRecordUseCaseParams.empty({this.userId = '', this.id = ''});

  @override
  List<Object> get props => [userId, id];
}
