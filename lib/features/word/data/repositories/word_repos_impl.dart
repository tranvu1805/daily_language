import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/data/data.dart';
import 'package:daily_language/features/word/domain/domain.dart';

class WordReposImpl implements WordRepos {
  final WordRemoteDataSource _remoteDataSource;

  WordReposImpl({required WordRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<Word>> getWords({
    required GetWordsUseCaseParams params,
  }) {
    return ApiService.handle(() async {
      final models = await _remoteDataSource.getWords(
        userId: params.userId,
        limit: pageSize,
        lastDocId: params.lastDocId,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  ResultFuture<Word> getWord({required GetWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final model = await _remoteDataSource.getWord(
        userId: params.userId,
        id: params.id,
      );
      return model.toEntity();
    });
  }

  @override
  ResultVoid createWord({required CreateWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final wordModel = WordModel.toCreate(
        meaning: params.meaning,
        category: params.category,
        wordText: params.wordText,
        imageUrls: params.imageUrls,
        isBookmarked: params.isBookmarked,
      );
      await _remoteDataSource.createWord(
        userId: params.userId,
        word: wordModel,
      );
    });
  }

  @override
  ResultVoid updateWord({required UpdateWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final wordModel = WordModel.toUpdate(
        id: params.id,
        meaning: params.meaning,
        category: params.category,
        wordText: params.wordText,
        imageUrls: params.imageUrls,
        isBookmarked: params.isBookmarked,
      );
      await _remoteDataSource.updateWord(
        userId: params.userId,
        word: wordModel,
      );
    });
  }

  @override
  ResultVoid deleteWord({required String id}) {
    throw UnimplementedError();
  }
}
