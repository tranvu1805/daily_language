import 'package:equatable/equatable.dart';

import '../../domain/entities/grammar_correction.dart';

class GrammarCorrectionModel extends Equatable {
  final String? original;
  final String? corrected;
  final String? explanation;
  final bool? hasErrors;

  const GrammarCorrectionModel({
    this.original,
    this.corrected,
    this.explanation,
    this.hasErrors,
  });

  GrammarCorrection toEntity() {
    return GrammarCorrection(
      original: original ?? '',
      corrected: corrected ?? '',
      explanation: explanation ?? '',
      hasErrors: hasErrors ?? false,
    );
  }

  factory GrammarCorrectionModel.fromJson(Map<String, dynamic> json) {
    return GrammarCorrectionModel(
      original: json['original'],
      corrected: json['corrected'],
      explanation: json['explanation'],
      hasErrors: json['hasErrors'],
    );
  }

  @override
  List<Object?> get props => [original, corrected, explanation, hasErrors];
}
