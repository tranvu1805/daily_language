import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/record/presentation/widgets/type_chip.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  List<String> _getCategories(BuildContext context) => [
    context.l10n.daily,
    context.l10n.study,
    context.l10n.work,
    context.l10n.travel,
    context.l10n.food,
    context.l10n.other,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _getCategories(context).map((type) {
        final isSelected = selectedCategory == type;
        return TypeChip(
          label: type,
          isSelected: isSelected,
          onTap: () => onCategorySelected(type),
        );
      }).toList(),
    );
  }
}
