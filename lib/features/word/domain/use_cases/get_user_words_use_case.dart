import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class GetUserWordsUseCase
    implements UseCaseWithParams<List<UserWord>, GetUserWordsUseCaseParams> {
  final WordRepos _repository;

  const GetUserWordsUseCase(this._repository);

  @override
  ResultFuture<List<UserWord>> call(GetUserWordsUseCaseParams params) async =>
      await _repository.getWords(params: params);
}

class GetUserWordsUseCaseParams extends Equatable {
  final String userId;
  final int limit;
  final String? lastDocId;
  final bool isReview;

  const GetUserWordsUseCaseParams({
    required this.userId,
    required this.limit,
    this.lastDocId,
    this.isReview = false,
  });

  @override
  List<Object?> get props => [userId, limit, lastDocId, isReview];
}
