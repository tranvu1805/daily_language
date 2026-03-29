import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/widgets/word_type_badge.dart';
import 'package:flutter/material.dart';

class WordDetailHeader extends StatelessWidget {
  final Word word;
  final VoidCallback? onPlayAudio;

  const WordDetailHeader({
    super.key,
    required this.word,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            word.content,
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorApp.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                word.pronunciation,
                style: textTheme.bodyMedium?.copyWith(
                  color: ColorApp.textSecondary,
                ),
              ),
              if (word.audioUs.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onPlayAudio,
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: ColorApp.primary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              WordTypeBadge(
                label: word.type,
                bgColor: ColorApp.cyanBlue,
                textColor: ColorApp.charcoalBlue,
              ),
              WordTypeBadge(
                label: word.level.toUpperCase(),
                bgColor: ColorApp.lightOrange,
                textColor: ColorApp.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
