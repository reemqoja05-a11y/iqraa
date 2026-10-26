import 'package:flutter/material.dart';

import '../../../models/book.dart';
import '../../../theme/app_theme.dart';

/// Selectable category chip used in the library filter bar.
class CategoryChip extends StatelessWidget {
  final BookCategory category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text(
        category.label,
        style: TextStyle(
          color: selected ? AppColors.onPrimary : AppColors.secondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
      checkmarkColor: AppColors.onPrimary,
      backgroundColor: AppColors.secondaryContainer,
      selectedColor: AppColors.primary,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
