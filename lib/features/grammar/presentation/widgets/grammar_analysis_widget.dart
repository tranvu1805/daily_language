import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/grammar/domain/entities/grammar_correction.dart';
import 'package:daily_language/features/grammar/presentation/widgets/grammar_correction_card.dart';
import 'package:flutter/material.dart';

class GrammarAnalysisWidget extends StatelessWidget {
  final GrammarCorrection correction;

  const GrammarAnalysisWidget({
    super.key,
    required this.correction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: ColorApp.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.aiAnalysis,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorApp.charcoalBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GrammarCorrectionCard(correction: correction),
        const SizedBox(height: 24),
        Text(
          l10n.detailedExplanation,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorApp.charcoalBlue,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorApp.cyanBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorApp.cyanBlue.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            correction.explanation,
            style: textTheme.bodyLarge?.copyWith(
              color: ColorApp.charcoalBlue,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
