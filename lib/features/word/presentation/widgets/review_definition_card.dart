import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';

class ReviewDefinitionCard extends StatelessWidget {
  final String meaningEn;
  final String? meaningVi;
  final bool isShowingAnswer;

  const ReviewDefinitionCard({
    super.key,
    required this.meaningEn,
    this.meaningVi,
    this.isShowingAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: ColorApp.primary,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.definition,
            style: textTheme.labelLarge?.copyWith(
              color: ColorApp.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meaningEn,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: ColorApp.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isShowingAnswer && (meaningVi != null && meaningVi!.isNotEmpty)) ...[
            const Divider(height: 32),
            Text(
              meaningVi!,
              style: textTheme.titleMedium?.copyWith(
                color: ColorApp.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
