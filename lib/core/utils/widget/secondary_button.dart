import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.onPressed, required this.label});
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ColorApp.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorApp.primary, width: 2),
        ),
        child: Center(
          child: Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
