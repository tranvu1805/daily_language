import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/word/domain/domain.dart';

abstract interface class WordRepos {
  ResultFuture<List<Word>> getWords({
    required GetWordsUseCaseParams params,
  });

  ResultFuture<Word> getWord({required GetWordUseCaseParams params});

  ResultVoid createWord({required CreateWordUseCaseParams params});

  ResultVoid updateWord({required UpdateWordUseCaseParams params});

  ResultVoid deleteWord({required String id});
}
