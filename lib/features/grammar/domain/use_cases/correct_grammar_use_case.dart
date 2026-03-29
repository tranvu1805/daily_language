import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:equatable/equatable.dart';

import '../entities/grammar_correction.dart';
import '../repositories/grammar_repository.dart';

class CorrectGrammarUseCase
    implements
        UseCaseWithParams<GrammarCorrection, GetGrammarCorrectionParams> {
  final GrammarRepository _repository;

  CorrectGrammarUseCase(this._repository);

  @override
  ResultFuture<GrammarCorrection> call(
    GetGrammarCorrectionParams params,
  ) async {
    return _repository.correctGrammar(params);
  }
}

class GetGrammarCorrectionParams extends Equatable {
  final String text;
  final String language;

  const GetGrammarCorrectionParams({required this.text, this.language = 'en'});

  @override
  List<Object> get props => [text, language];
}
