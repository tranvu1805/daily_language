import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class WordDetailExampleCard extends StatelessWidget {
  final String example;

  const WordDetailExampleCard({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    if (example.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorApp.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorApp.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 20,
            color: ColorApp.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              example,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorApp.textPrimary,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
