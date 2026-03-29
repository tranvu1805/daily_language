import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LevelData {
  final String id;
  final String label;
  final String subtitle;
  final String wordCount;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const LevelData({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.wordCount,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  static List<LevelData> getLevels(AppLocalizations l10n) => [
        LevelData(
          id: 'A1',
          label: 'A1',
          subtitle: l10n.beginner,
          wordCount: l10n.wordsCount(500),
          color: ColorApp.levelA1,
          bgColor: ColorApp.levelA1Bg,
          icon: Icons.emoji_nature_rounded,
        ),
        LevelData(
          id: 'A2',
          label: 'A2',
          subtitle: l10n.elementary,
          wordCount: l10n.wordsCount(700),
          color: ColorApp.levelA2,
          bgColor: ColorApp.levelA2Bg,
          icon: Icons.local_florist_rounded,
        ),
        LevelData(
          id: 'B1',
          label: 'B1',
          subtitle: l10n.intermediate,
          wordCount: l10n.wordsCount(1200),
          color: ColorApp.levelB1,
          bgColor: ColorApp.levelB1Bg,
          icon: Icons.bolt_rounded,
        ),
        LevelData(
          id: 'B2',
          label: 'B2',
          subtitle: l10n.upperIntermediate,
          wordCount: l10n.wordsCount(1500),
          color: ColorApp.levelB2,
          bgColor: ColorApp.levelB2Bg,
          icon: Icons.local_fire_department_rounded,
        ),
        LevelData(
          id: 'C1',
          label: 'C1',
          subtitle: l10n.advanced,
          wordCount: l10n.wordsCount(1000),
          color: ColorApp.levelC1,
          bgColor: ColorApp.levelC1Bg,
          icon: Icons.auto_awesome_rounded,
        ),
      ];
}
