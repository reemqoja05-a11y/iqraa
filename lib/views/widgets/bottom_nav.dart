import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Destinations shown in the bottom navigation bar (right-to-left order in Arabic).
enum AppDestination {
  home,
  library,
  groups,
  achievements,
}

extension AppDestinationExtension on AppDestination {
  String get label {
    switch (this) {
      case AppDestination.home:
        return 'الرئيسية';
      case AppDestination.library:
        return 'المكتبة';
      case AppDestination.groups:
        return 'المجموعات';
      case AppDestination.achievements:
        return 'إنجازاتي';
    }
  }

  IconData get icon {
    switch (this) {
      case AppDestination.home:
        return Icons.home;
      case AppDestination.library:
        return Icons.local_library;
      case AppDestination.groups:
        return Icons.group;
      case AppDestination.achievements:
        return Icons.emoji_events;
    }
  }
}

/// Material 3 bottom navigation bar with four destinations, matching the designs.
class AppBottomNav extends StatelessWidget {
  final AppDestination selected;
  final ValueChanged<AppDestination> onDestinationSelected;

  const AppBottomNav({
    super.key,
    required this.selected,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<AppDestination> values = AppDestination.values;
    // The bar grows with the system text size so the labels are never
    // clipped, while keeping the designed 80dp height at the default size.
    final double textScale =
        MediaQuery.textScalerOf(context).scale(11) / 11;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowTint,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // The safe-area inset is applied *around* the bar so the surface keeps
      // covering the area behind the system navigation bar.
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80 + 14 * (textScale - 1),
          child: Row(
            children: List.generate(values.length, (index) {
              final AppDestination destination = values[index];
              final bool isSelected = selected == destination;
              return Expanded(
                child: _DestinationItem(
                  destination: destination,
                  isSelected: isSelected,
                  onTap: () => onDestinationSelected(destination),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _DestinationItem extends StatelessWidget {
  final AppDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _DestinationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryContainer : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                destination.icon,
                size: 24,
                color: isSelected ? AppColors.primary : AppColors.secondary,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
