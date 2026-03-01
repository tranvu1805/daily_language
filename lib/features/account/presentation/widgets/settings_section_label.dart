import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      label,
      style: textTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ColorApp.taupeGray,
      ),
    );
  }
}
