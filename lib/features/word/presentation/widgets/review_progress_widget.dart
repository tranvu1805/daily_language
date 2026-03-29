import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';

class ReviewProgressWidget extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const ReviewProgressWidget({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final progress = (currentIndex + 1) / totalCount;

    return Row(
      children: [
        Text(
          context.l10n.wordCountProgress(currentIndex + 1, totalCount),
          style: textTheme.bodySmall?.copyWith(
            color: ColorApp.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: ColorApp.primary.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(ColorApp.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
