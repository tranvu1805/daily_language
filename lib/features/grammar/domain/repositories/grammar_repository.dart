import 'package:daily_language/core/utils/helper/type_definition.dart';
import '../entities/grammar_correction.dart';

abstract interface class GrammarRepository {
  ResultFuture<GrammarCorrection> correctGrammar(String text);
}
