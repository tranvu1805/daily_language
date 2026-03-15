import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetWordUseCase
    implements UseCaseWithParams<Word, GetWordUseCaseParams> {
  const GetWordUseCase(this._repository);

  final WordRepos _repository;

  @override
  ResultFuture<Word> call(GetWordUseCaseParams params) =>
      _repository.getWord(params: params);
}

class GetWordUseCaseParams extends Equatable {
  final String userId;
  final String id;

  const GetWordUseCaseParams({required this.userId, required this.id});

  const GetWordUseCaseParams.empty({this.userId = '', this.id = ''});

  @override
  List<Object> get props => [userId, id];
}
