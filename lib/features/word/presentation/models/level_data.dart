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
}
