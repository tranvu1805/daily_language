import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class CreateUserWordUseCase
    implements UseCaseWithParams<void, CreateUserWordUseCaseParams> {
  final WordRepos _repository;

  const CreateUserWordUseCase(this._repository);

  @override
  ResultVoid call(CreateUserWordUseCaseParams params) async =>
      await _repository.createWord(params: params);
}

class CreateUserWordUseCaseParams extends Equatable {
  final String userId;
  final String wordId;
  final String word;
  final String level;
  final int repetitionCount;
  final int wrongCount;
  final int stage;
  final DateTime lastReviewed;
  final DateTime nextReview;
  final num easeFactor;
  final num interval;

  const CreateUserWordUseCaseParams({
    required this.userId,
    required this.wordId,
    required this.word,
    required this.repetitionCount,
    required this.level,
    required this.wrongCount,
    required this.stage,
    required this.lastReviewed,
    required this.nextReview,
    required this.easeFactor,
    required this.interval,
  });

  @override
  List<Object?> get props => [
    userId,
    wordId,
    word,
    repetitionCount,
    wrongCount,
    level,
    stage,
    lastReviewed,
    nextReview,
    easeFactor,
    interval,
  ];
}
