import 'package:daily_language/core/utils/helper/type_definition.dart';
import 'package:daily_language/features/grammar/domain/domain.dart';

abstract interface class GrammarRepository {
  ResultFuture<GrammarCorrection> correctGrammar(
    GetGrammarCorrectionParams param,
  );
}
