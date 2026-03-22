import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetUserWordUseCase
    implements UseCaseWithParams<UserWord, GetUserWordUseCaseParams> {
  final WordRepos _repository;

  const GetUserWordUseCase(this._repository);

  @override
  ResultFuture<UserWord> call(GetUserWordUseCaseParams params) async =>
      await _repository.getWord(params: params);
}

class GetUserWordUseCaseParams extends Equatable {
  final String userId;
  final String wordId;

  const GetUserWordUseCaseParams({required this.userId, required this.wordId});

  @override
  List<Object?> get props => [userId, wordId];
}
