import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/helper/date_time_helper.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  const WordCard({super.key, required this.word, this.onTap});

  final UserWord word;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word.isEmpty ? 'Unknown' : word.word,
                        style: textTheme.titleMedium?.copyWith(
                          color: ColorApp.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Next review: ${DateTimeHelper.formatDate(word.nextReview)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: ColorApp.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorApp.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Stage ${word.stage}',
                    style: textTheme.labelSmall?.copyWith(
                      color: ColorApp.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
