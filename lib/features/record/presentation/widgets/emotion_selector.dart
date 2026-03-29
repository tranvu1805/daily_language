import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/record/presentation/widgets/emotion_chip.dart';
import 'package:flutter/material.dart';

class EmotionSelector extends StatelessWidget {
  final String selectedEmotion;
  final Function(String) onEmotionSelected;

  const EmotionSelector({
    super.key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  List<String> _getEmotions(BuildContext context) => [
    '😊 ${context.l10n.happy}',
    '😢 ${context.l10n.sad}',
    '😡 ${context.l10n.angry}',
    '😨 ${context.l10n.scared}',
    '😌 ${context.l10n.calm}',
    '🤔 ${context.l10n.thinking}',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _getEmotions(context).map((emotion) {
        final isSelected = selectedEmotion == emotion;
        return EmotionChip(
          label: emotion,
          isSelected: isSelected,
          onTap: () => onEmotionSelected(emotion),
        );
      }).toList(),
    );
  }
}
