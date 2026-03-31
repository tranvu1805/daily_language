import 'package:daily_language/core/utils/utils.dart';
import 'package:flutter/material.dart';

class ReviewCompletionDialog extends StatelessWidget {
  const ReviewCompletionDialog({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.reviewCompleted,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reviewFinishedMessage,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: PrimaryButton(
              onPressed: onPressed,
              label: l10n.backToLearning,
            ),
          ),
        ],
      ),
    );
  }
}
