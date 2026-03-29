import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/helper/date_time_helper.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record, this.onTap});

  final Record record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorApp.darkGray.withAlpha(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateTimeHelper.formatDate(record.createdAt),
                    style: textTheme.labelLarge,
                  ),
                ),
                if (record.emotion.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: ColorApp.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      record.emotion,
                      style: textTheme.bodySmall?.copyWith(
                        color: ColorApp.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (record.englishContent.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                record.englishContent,
                style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
