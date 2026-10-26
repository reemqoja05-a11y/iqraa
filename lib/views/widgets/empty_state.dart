import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import 'app_button.dart';

/// Generic empty state illustration with title, description and a primary action.
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryAction;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 44)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 26),
            AppButton(
              text: actionLabel,
              type: AppButtonType.primary,
              onPressed: onAction,
            ),
            if (secondaryLabel != null) ...[
              const SizedBox(height: 12),
              AppButton(
                text: secondaryLabel!,
                type: AppButtonType.outline,
                onPressed: onSecondaryAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
