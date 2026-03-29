import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';

class ReviewFeedbackWidget extends StatelessWidget {
  final bool isCorrect;

  const ReviewFeedbackWidget({super.key, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isCorrect ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: color,
          ),
          const SizedBox(width: 12),
          Text(
            isCorrect
                ? context.l10n.correctKeepItUp
                : context.l10n.incorrectWordIsAbove,
            style: textTheme.bodyMedium?.copyWith(
              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
