import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class DeleteUserWordUseCase
    implements UseCaseWithParams<void, DeleteUserWordUseCaseParams> {
  final WordRepos _repository;

  const DeleteUserWordUseCase(this._repository);

  @override
  ResultVoid call(DeleteUserWordUseCaseParams params) async =>
      await _repository.deleteWord(params: params);
}

class DeleteUserWordUseCaseParams extends Equatable {
  final String userId;
  final String wordId;

  const DeleteUserWordUseCaseParams({
    required this.userId,
    required this.wordId,
  });

  @override
  List<Object?> get props => [userId, wordId];
}
