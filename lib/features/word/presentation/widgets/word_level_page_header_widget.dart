import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class WordLevelPageHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onBack;
  final VoidCallback? onAdd;

  const WordLevelPageHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onBack,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: ColorApp.textPrimary,
              ),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorApp.textPrimary,
                  ),
                ),
              ),
              if (onAdd != null)
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: ColorApp.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
