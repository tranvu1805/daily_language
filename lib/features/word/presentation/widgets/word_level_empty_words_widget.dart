import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class WordLevelEmptyWordsWidget extends StatelessWidget {
  final Color accentColor;
  const WordLevelEmptyWordsWidget({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_outline_rounded,
                size: 40,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No words yet',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorApp.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding words from your diary\nor tap + to add manually.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: ColorApp.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
