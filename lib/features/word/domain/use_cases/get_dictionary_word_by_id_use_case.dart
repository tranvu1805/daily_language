import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetDictionaryWordByIdUseCase
    implements UseCaseWithParams<Word, GetDictionaryWordByIdUseCaseParams> {
  final WordRepos _repository;

  const GetDictionaryWordByIdUseCase(this._repository);

  @override
  ResultFuture<Word> call(GetDictionaryWordByIdUseCaseParams params) async =>
      await _repository.getDictionaryWordById(id: params.id, level: params.level);
}

class GetDictionaryWordByIdUseCaseParams extends Equatable {
  final String id;
  final String? level;

  const GetDictionaryWordByIdUseCaseParams({required this.id, this.level});

  @override
  List<Object?> get props => [id, level];
}
