import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class WordDetailRelationList extends StatelessWidget {
  final String label;
  final List<String> items;

  const WordDetailRelationList({
    super.key,
    required this.label,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorApp.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (e) => Text(
                    e,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorApp.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
