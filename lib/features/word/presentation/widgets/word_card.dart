import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/helper/date_time_helper.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  const WordCard({super.key, required this.word, this.onTap});

  final Word word;
  final VoidCallback? onTap;

  // Helper method based on Figma to choose colors dynamically per Category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'environment':
        return Colors.green.shade700;
      case 'career':
      case 'work':
        return Colors.blue.shade700;
      case 'wellness':
        return Colors.purple.shade700;
      case 'technology':
        return Colors.orange.shade700;
      default:
        return Colors.indigo.shade400;
    }
  }

  Color _getCategoryBgColor(String category) {
    switch (category.toLowerCase()) {
      case 'environment':
        return Colors.green.shade100;
      case 'career':
      case 'work':
        return Colors.blue.shade100;
      case 'wellness':
        return Colors.purple.shade100;
      case 'technology':
        return Colors.orange.shade100;
      default:
        return Colors.indigo.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final catColor = _getCategoryColor(word.category);
    final catBgColor = _getCategoryBgColor(word.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.wordText.isEmpty ? 'Unknown' : word.wordText,
                        style: textTheme.titleMedium?.copyWith(
                          color: const Color(0xff111827),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Added ${DateTimeHelper.formatDate(word.createdAt)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xff6b7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    word.isBookmarked ? Icons.favorite : Icons.favorite_outline,
                    color: word.isBookmarked ? const Color(0xffef4444) : Colors.grey,
                  ),
                  onPressed: () {
                    // TODO: Toggle bookmark
                  },
                ),
              ],
            ),
            if (word.meaning.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                word.meaning,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xff374151),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: catBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.label_important, size: 14, color: catColor),
                      const SizedBox(width: 4),
                      Text(
                        word.category.isEmpty ? 'General' : word.category,
                        style: textTheme.labelSmall?.copyWith(
                          color: catColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    size: 16,
                    color: Color(0xff6366f1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
