import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetRecordsUseCase
    implements UseCaseWithParams<List<Record>, GetRecordsUseCaseParams> {
  final RecordRepos _repository;

  const GetRecordsUseCase(this._repository);

  @override
  ResultFuture<List<Record>> call(GetRecordsUseCaseParams params) async =>
      await _repository.getRecords(params: params);
}

class GetRecordsUseCaseParams extends Equatable {
  final String userId;
  final String? lastDocId;

  const GetRecordsUseCaseParams({required this.userId, this.lastDocId});

  const GetRecordsUseCaseParams.empty({this.userId = '', this.lastDocId});

  @override
  List<Object?> get props => [userId, lastDocId];
}
