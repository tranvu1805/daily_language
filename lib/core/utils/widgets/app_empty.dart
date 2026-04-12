import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/generated/assets.dart';
import 'package:flutter/material.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.empty.image(width: 80, height: 80),
          const SizedBox(height: 4),
          Text(context.l10n.noData, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
