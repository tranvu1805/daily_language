import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/grammar/domain/entities/grammar_correction.dart';
import 'package:daily_language/features/grammar/presentation/widgets/grammar_label_badge.dart';
import 'package:flutter/material.dart';

class GrammarCorrectionCard extends StatelessWidget {
  final GrammarCorrection correction;

  const GrammarCorrectionCard({
    super.key,
    required this.correction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorApp.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: correction.hasErrors
              ? ColorApp.failedRed.withValues(alpha: 0.15)
              : ColorApp.green.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (correction.hasErrors) ...[
            GrammarLabelBadge(
              label: l10n.original,
              color: ColorApp.failedRed,
              icon: Icons.close_rounded,
            ),
            const SizedBox(height: 12),
            Text(
              correction.original,
              style: textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: ColorApp.taupeGray.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1, thickness: 0.5),
            ),
          ],
          GrammarLabelBadge(
            label: correction.hasErrors ? l10n.improved : l10n.perfect,
            color: ColorApp.green,
            icon: Icons.check_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            correction.corrected,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorApp.charcoalBlue,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
