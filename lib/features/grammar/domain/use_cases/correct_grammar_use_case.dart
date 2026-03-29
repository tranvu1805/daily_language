import 'package:daily_language/core/use_case/use_case.dart';
import 'package:daily_language/core/utils/helper/type_definition.dart';
import '../entities/grammar_correction.dart';
import '../repositories/grammar_repository.dart';

class CorrectGrammarUseCase implements UseCaseWithParams<GrammarCorrection, String> {
  final GrammarRepository _repository;

  CorrectGrammarUseCase(this._repository);

  @override
  ResultFuture<GrammarCorrection> call(String params) async {
    return _repository.correctGrammar(params);
  }
}
