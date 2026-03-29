import 'package:equatable/equatable.dart';

class GrammarCorrection extends Equatable {
  final String original;
  final String corrected;
  final String explanation;
  final bool hasErrors;

  const GrammarCorrection({
    required this.original,
    required this.corrected,
    required this.explanation,
    required this.hasErrors,
  });

  @override
  List<Object> get props => [original, corrected, explanation, hasErrors];
}
