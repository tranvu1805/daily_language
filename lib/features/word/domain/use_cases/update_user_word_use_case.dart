import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UpdateUserWordUseCase
    implements UseCaseWithParams<void, UpdateUserWordUseCaseParams> {
  final WordRepos _repository;

  const UpdateUserWordUseCase(this._repository);

  @override
  ResultVoid call(UpdateUserWordUseCaseParams params) async =>
      await _repository.updateWord(params: params);
}

class UpdateUserWordUseCaseParams extends Equatable {
  final String id;
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

  const UpdateUserWordUseCaseParams({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.word,
    required this.repetitionCount,
    required this.wrongCount,
    required this.stage,
    required this.lastReviewed,
    required this.nextReview,
    required this.easeFactor,
    required this.interval,
    required this.level,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    wordId,
    level,
    word,
    repetitionCount,
    wrongCount,
    stage,
    lastReviewed,
    nextReview,
    easeFactor,
    interval,
  ];
}
