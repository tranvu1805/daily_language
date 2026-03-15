import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:equatable/equatable.dart';

class CreateWordUseCase
    implements UseCaseWithParams<void, CreateWordUseCaseParams> {
  final WordRepos _repository;

  const CreateWordUseCase(this._repository);

  @override
  ResultVoid call(CreateWordUseCaseParams params) async =>
      await _repository.createWord(params: params);
}

class CreateWordUseCaseParams extends Equatable {
  final String userId;
  final String meaning;
  final String category;
  final String wordText;
  final List<String>? imageUrls;
  final bool? isBookmarked;

  const CreateWordUseCaseParams({
    required this.userId,
    required this.meaning,
    required this.category,
    required this.wordText,
    this.imageUrls,
    this.isBookmarked,
  });

  const CreateWordUseCaseParams.empty({
    this.userId = '',
    this.meaning = '',
    this.category = '',
    this.wordText = '',
    this.imageUrls,
    this.isBookmarked,
  });

  @override
  List<Object?> get props => [userId, meaning, category, wordText, imageUrls, isBookmarked];
}
