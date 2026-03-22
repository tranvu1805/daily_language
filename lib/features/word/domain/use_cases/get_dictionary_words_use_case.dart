import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetDictionaryWordsUseCase
    implements UseCaseWithParams<List<Word>, GetDictionaryWordsUseCaseParams> {
  final WordRepos _repository;

  const GetDictionaryWordsUseCase(this._repository);

  @override
  ResultFuture<List<Word>> call(GetDictionaryWordsUseCaseParams params) async =>
      await _repository.getDictionaryWords(params: params);
}

class GetDictionaryWordsUseCaseParams extends Equatable {
  final String level;
  final int limit;
  final String? lastId;

  const GetDictionaryWordsUseCaseParams({
    required this.level,
    required this.limit,
    this.lastId,
  });

  @override
  List<Object?> get props => [level, limit, lastId];
}
