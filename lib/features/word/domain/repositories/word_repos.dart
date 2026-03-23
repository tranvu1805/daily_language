import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';

abstract interface class WordRepos {
  ResultFuture<List<UserWord>> getWords({
    required GetUserWordsUseCaseParams params,
  });

  ResultFuture<List<Word>> getDictionaryWords({
    required GetDictionaryWordsUseCaseParams params,
  });

  ResultFuture<Word> getDictionaryWordById({
    required String id,
    String? level,
  });

  ResultFuture<UserWord> getWord({required GetUserWordUseCaseParams params});

  ResultVoid createWord({required CreateUserWordUseCaseParams params});

  ResultVoid updateWord({required UpdateUserWordUseCaseParams params});

  ResultVoid deleteWord({required DeleteUserWordUseCaseParams params});
}
