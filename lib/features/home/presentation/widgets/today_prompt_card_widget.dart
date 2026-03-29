import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TodayPromptCardWidget extends StatelessWidget {
  const TodayPromptCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorApp.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.todayPrompt, style: textTheme.labelLarge),
                    Text(
                      DateFormat('MMMM d, yyyy', locale).format(DateTime.now()),
                      style: textTheme.bodySmall?.copyWith(
                        color: ColorApp.taupeGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '"${l10n.todayPromptQuestion}"',
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: ColorApp.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  '${Routes.diary}/${Routes.diaryAdd}',
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(l10n.write),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorApp.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
