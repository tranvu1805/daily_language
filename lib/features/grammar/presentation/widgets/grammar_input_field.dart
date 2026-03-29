import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';

class GrammarInputField extends StatelessWidget {
  final TextEditingController controller;

  const GrammarInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorApp.charcoalBlue.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 8,
        style: textTheme.bodyLarge?.copyWith(color: ColorApp.charcoalBlue),
        decoration: InputDecoration(
          hintText: l10n.grammarCheckHint,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: ColorApp.taupeGray.withValues(alpha: 0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
