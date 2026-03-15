import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class UpdateWordUseCase
    implements UseCaseWithParams<void, UpdateWordUseCaseParams> {
  final WordRepos _repository;

  const UpdateWordUseCase(this._repository);

  @override
  ResultVoid call(UpdateWordUseCaseParams params) async =>
      await _repository.updateWord(params: params);
}

class UpdateWordUseCaseParams extends Equatable {
  final String userId;
  final String id;
  final String meaning;
  final String category;
  final String wordText;
  final List<String>? imageUrls;
  final bool? isBookmarked;

  const UpdateWordUseCaseParams({
    required this.userId,
    required this.id,
    required this.meaning,
    required this.category,
    required this.wordText,
    this.imageUrls,
    this.isBookmarked,
  });

  const UpdateWordUseCaseParams.empty({
    this.userId = '',
    this.id = '',
    this.meaning = '',
    this.category = '',
    this.wordText = '',
    this.imageUrls,
    this.isBookmarked,
  });

  @override
  List<Object?> get props => [userId, id, meaning, category, wordText, imageUrls, isBookmarked];
}
