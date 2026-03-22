import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/features/word/presentation/models/level_data.dart';
import 'package:flutter/material.dart';

class LevelCardWidget extends StatelessWidget {
  final LevelData level;
  final VoidCallback onTap;
  const LevelCardWidget({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: level.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(level.icon, color: level.color, size: 18),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: level.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level.label,
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      color: level.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              level.label,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: level.color,
              ),
            ),
            Text(
              level.subtitle,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              level.wordCount,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: ColorApp.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
