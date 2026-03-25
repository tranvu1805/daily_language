import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:equatable/equatable.dart';

class TranslateVietnameseToEnglishUseCase
    implements
        UseCaseWithParams<String, TranslateVietnameseToEnglishUseCaseParams> {
  final RecordRepos _repository;

  const TranslateVietnameseToEnglishUseCase(this._repository);

  @override
  ResultFuture<String> call(TranslateVietnameseToEnglishUseCaseParams params) {
    return _repository.translateVietnameseToEnglish(params: params);
  }
}

class TranslateVietnameseToEnglishUseCaseParams extends Equatable {
  final String content;

  const TranslateVietnameseToEnglishUseCaseParams({required this.content});

  @override
  List<Object> get props => [content];
}
