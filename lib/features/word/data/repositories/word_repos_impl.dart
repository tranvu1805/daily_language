import 'package:daily_language/core/network/api_service.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/data/data.dart';
import 'package:daily_language/features/word/data/models/user_word_model.dart';
import 'package:daily_language/features/word/domain/domain.dart';

class WordReposImpl implements WordRepos {
  final UserWordRemoteDataSource _remoteDataSource;
  final WordLocalDataSource _localDataSource;

  WordReposImpl({
    required UserWordRemoteDataSource remoteDataSource,
    required WordLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  ResultFuture<List<UserWord>> getWords({
    required GetUserWordsUseCaseParams params,
  }) {
    return ApiService.handle(() async {
      final models = await _remoteDataSource.getWords(
        userId: params.userId,
        limit: params.limit,
        lastDocId: params.lastDocId,
        isReview: params.isReview,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  ResultFuture<UserWord> getWord({required GetUserWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final model = await _remoteDataSource.getWord(
        userId: params.userId,
        id: params.wordId,
      );
      return model.toEntity();
    });
  }

  @override
  ResultFuture<List<Word>> getDictionaryWords({
    required GetDictionaryWordsUseCaseParams params,
  }) {
    return ApiService.handle(() async {
      final models = await _localDataSource.getWordsFromAssets(
        level: params.level,
        limit: params.limit,
        lastId: params.lastId,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  ResultFuture<Word> getDictionaryWordById({
    required String id,
    String? level,
  }) {
    return ApiService.handle(() async {
      final model = await _localDataSource.getWordByIdFromAllAssets(id: id, level: level);
      if (model == null) {
        throw Exception('Word not found in dictionary');
      }
      return model.toEntity();
    });
  }

  @override
  ResultVoid createWord({required CreateUserWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final userWordModel = UserWordModel.fromCreateParams(params);
      await _remoteDataSource.createWord(
        userId: params.userId,
        word: userWordModel,
      );
    });
  }

  @override
  ResultVoid updateWord({required UpdateUserWordUseCaseParams params}) {
    return ApiService.handle(() async {
      final userWordModel = UserWordModel.fromUpdateParams(params);
      await _remoteDataSource.updateWord(
        userId: params.userId,
        word: userWordModel,
      );
    });
  }

  @override
  ResultVoid deleteWord({required DeleteUserWordUseCaseParams params}) {
    return ApiService.handle(() async {
      await _remoteDataSource.deleteWord(
        userId: params.userId,
        id: params.wordId,
      );
    });
  }
}
