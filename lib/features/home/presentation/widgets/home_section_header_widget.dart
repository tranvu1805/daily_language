import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class HomeSectionHeaderWidget extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const HomeSectionHeaderWidget({
    super.key,
    required this.title,
    required this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textTheme.labelLarge),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorApp.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
