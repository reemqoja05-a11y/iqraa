import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Returns the factor the system text is currently scaled by.
///
/// `1.0` at the default system text size, larger values follow the user's
/// accessibility setting. Fixed-height areas (pinned app bars, chip rows,
/// carousels) use it to grow with the text instead of clipping it.
double textScaleFactor(BuildContext context, {double fontSize = 12}) {
  final TextScaler scaler = MediaQuery.textScalerOf(context);
  return scaler.scale(fontSize) / fontSize;
}

/// Warm brown & beige palette extracted from the Google Stitch designs
/// ("Warm Editorial Sanctuary" / "Warm Editorial Serenity").
///
/// All colors are chosen to preserve the original visual identity:
/// cream/ivory backgrounds, deep earthy brown primary actions, olive
/// metadata, and soft parchment outlines.
class AppColors {
  // Background & surfaces
  static const Color background = Color(0xFFFBF6EE); // warm ivory canvas
  static const Color surface = Color(0xFFFFFFFF); // elevated card surface
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainer = Color(0xFFF1E4D3); // section cards
  static const Color surfaceContainerHigh = Color(0xFFEFEBE9);
  static const Color surfaceBright = Color(0xFFFCF9F4);

  // Brand (deep earthy browns)
  static const Color primary = Color(0xFF6B4630); // primary CTA, active states
  static const Color primaryContainer = Color(0xFF795548);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFFFDBCF);
  static const Color primaryFixedDim = Color(0xFFEBCAC);
  static const Color secondaryFixedDim = Color(0xFFC9C6C4);
  static const Color onPrimaryFixed = Color(0xFF2E150B);

  // Secondary (olive)
  static const Color secondary = Color(0xFF4F5D2F);
  static const Color secondaryContainer = Color(0xFFE6EBD3);
  static const Color onSecondaryContainer = Color(0xFF3E2A1E);

  // Tertiary (caramel / warm amber)
  static const Color tertiary = Color(0xFFA67C52);
  static const Color tertiaryContainer = Color(0xFF7B562F);
  static const Color onTertiaryContainer = Color(0xFFFFCEA0);
  static const Color amber = Color(0xFFD9A441); // restorative "catch up" accent

  // Text
  static const Color onSurface = Color(0xFF3E2A1E); // deep roasted walnut
  static const Color onSurfaceVariant = Color(0xFF504440); // muted stone
  static const Color onSurfaceLowVisibility = Color(0xFF786E65);

  // Borders & dividers
  static const Color outline = Color(0xFFCDAA85); // parchment hairline
  static const Color outlineVariant = Color(0xFFD8CEC3);
  static const Color divider = Color(0xFFE2D2BE);

  // Functional
  static const Color success = Color(0xFF4F7255); // sage moss (completed goals)
  static const Color error = Color(0xFFBA4A42); // terracotta crimson
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color shadowTint = Color(0x1A332820); // warm soft shadow

  static const Color onBackground = Color(0xFF3E2A1E);
}

/// Material 3 theme configured for the Iqra app.
///
/// Arabic is the primary language, so the theme defaults to RTL text direction.
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      surface: AppColors.surface,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onPrimary,
      error: AppColors.error,
      onError: AppColors.onPrimary,
      surfaceContainerHighest: AppColors.surfaceContainerHigh,
    ),
    textTheme: _buildTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.tertiary,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: TextStyle(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
        fontSize: 15,
      ),
      labelStyle: TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      space: 1,
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
  );

  static TextTheme _buildTextTheme() {
    final base = GoogleFonts.notoSansArabicTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 44 / 32,
        color: AppColors.onSurface,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 36 / 26,
        color: AppColors.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 32 / 22,
        color: AppColors.onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 28 / 18,
        color: AppColors.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: AppColors.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 30 / 18,
        color: AppColors.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 24 / 15,
        color: AppColors.onSurfaceVariant,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 20 / 13,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: AppColors.onSurfaceVariant,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.onSurfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 14 / 11,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
