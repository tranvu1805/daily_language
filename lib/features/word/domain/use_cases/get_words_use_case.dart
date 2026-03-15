import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetWordsUseCase
    implements UseCaseWithParams<List<Word>, GetWordsUseCaseParams> {
  final WordRepos _repository;

  const GetWordsUseCase(this._repository);

  @override
  ResultFuture<List<Word>> call(GetWordsUseCaseParams params) async =>
      await _repository.getWords(params: params);
}

class GetWordsUseCaseParams extends Equatable {
  final String userId;
  final String? lastDocId;

  const GetWordsUseCaseParams({required this.userId, this.lastDocId});

  const GetWordsUseCaseParams.empty({this.userId = '', this.lastDocId});

  @override
  List<Object?> get props => [userId, lastDocId];
}
