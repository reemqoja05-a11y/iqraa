import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

enum AppButtonType { primary, secondary, outline, ghost }

/// Reusable action button matching the design system:
/// primary fill #6B4630, 52dp height, 16dp radius.
///
/// The button is layout-safe by construction:
///  * it stretches to the available width whenever the parent bounds it
///    (the full-width call-to-action of the designs);
///  * it keeps its intrinsic width when it is placed inside a [Row], where
///    the incoming width is unbounded;
///  * the caption is flexible, so a long Arabic label wraps (or ellipsizes)
///    instead of overflowing the button.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonType type;
  final bool isLoading;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.height,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // A bounded width means the button may stretch to fill it, which is
        // what the designs show for the primary call-to-action. An unbounded
        // width (inside a Row) keeps the button at its natural size instead
        // of asking for an infinite one.
        final bool stretch = constraints.hasBoundedWidth;
        final double minWidth = stretch ? double.infinity : 0;

        final Widget label = Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        );

        final Widget content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                ),
              )
            else if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            // A flexible caption keeps long Arabic labels inside the button.
            if (stretch) Flexible(child: label) else label,
          ],
        );

        final double buttonHeight = height ?? (type == AppButtonType.ghost ? 48 : 52);
        final RoundedRectangleBorder shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(type == AppButtonType.ghost ? 12 : 16),
        );

        final Widget button = switch (type) {
          AppButtonType.primary => ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(minWidth, buttonHeight),
                shape: shape,
              ),
              child: content,
            ),
          AppButtonType.secondary => FilledButton(
              onPressed: disabled ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surfaceContainer,
                foregroundColor: AppColors.onSurface,
                minimumSize: Size(minWidth, buttonHeight),
                shape: shape,
              ),
              child: content,
            ),
          AppButtonType.outline => OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                minimumSize: Size(minWidth, buttonHeight),
                shape: shape,
              ),
              child: content,
            ),
          AppButtonType.ghost => TextButton(
              onPressed: disabled ? null : onPressed,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.tertiary,
                minimumSize: Size(minWidth, buttonHeight),
                shape: shape,
              ),
              child: content,
            ),
        };

        Widget result = button;
        if (width != null) {
          result = SizedBox(width: width, child: result);
        }
        if (margin != null) {
          result = Padding(padding: margin!, child: result);
        }
        return result;
      },
    );
  }
}
