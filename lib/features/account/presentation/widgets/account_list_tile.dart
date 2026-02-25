import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.title,
  });

  final String title;

  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final content = subtitle.isEmpty ? context.l10n.empty : subtitle;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: textTheme.labelLarge),
      subtitle: Text(content, style: textTheme.bodyMedium),
    );
  }
}
