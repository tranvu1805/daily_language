import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class WordDetailSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const WordDetailSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorApp.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorApp.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
