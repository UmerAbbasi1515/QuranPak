import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holy_quran/core/theme/app_palette.dart';

/// Typography helpers.
///
/// Latin text uses the Inter family bundled in `assets/fonts`; Arabic uses
/// Amiri Quran, which carries the Uthmani diacritics properly. Both are
/// bundled rather than fetched at runtime so the app renders correctly
/// offline.
class AppFontFamily {
  AppFontFamily._();

  static const String regular = 'InterRegular';
  static const String medium = 'InterMedium';
  static const String semibold = 'InterSemibold';
  static const String bold = 'InterBold';

  /// Mushaf script for verse text.
  static const String arabic = 'AmiriQuran';

  /// Amiri Bold, for surah names and ornamental headings.
  static const String arabicDisplay = 'Amiri';
}

class AppTextStyles {
  AppTextStyles._();

  /// Arabic mushaf text; [fontSize] comes from the reader font-size setting.
  static TextStyle arabic({
    required Color color,
    required double fontSize,
    double height = 2.0,
  }) =>
      TextStyle(
        fontFamily: AppFontFamily.arabic,
        color: color,
        fontSize: fontSize,
        height: height,
      );

  /// Arabic used for surah names and ornaments (shorter, tighter leading).
  static TextStyle arabicDisplay({
    required Color color,
    required double fontSize,
  }) =>
      TextStyle(
        fontFamily: AppFontFamily.arabicDisplay,
        color: color,
        fontSize: fontSize,
        height: 1.6,
        fontWeight: FontWeight.w700,
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppPalette.light);
  static ThemeData dark() => _build(AppPalette.dark);

  static ThemeData _build(AppPalette p) {
    final base = p.isDark ? ThemeData.dark() : ThemeData.light();

    final textTheme = base.textTheme
        .apply(
          fontFamily: AppFontFamily.regular,
          bodyColor: p.text,
          displayColor: p.text,
        )
        .copyWith(
          titleLarge: TextStyle(
            fontFamily: AppFontFamily.bold,
            fontSize: 20,
            color: p.text,
          ),
          titleMedium: TextStyle(
            fontFamily: AppFontFamily.semibold,
            fontSize: 16,
            color: p.text,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFontFamily.regular,
            fontSize: 14,
            height: 1.45,
            color: p.text,
          ),
          labelLarge: TextStyle(
            fontFamily: AppFontFamily.semibold,
            fontSize: 14,
            color: p.text,
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      dividerColor: p.border,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        brightness: p.brightness,
        primary: p.primary,
        onPrimary: p.onPrimary,
        secondary: p.gold,
        surface: p.surface,
        onSurface: p.text,
        outline: p.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFontFamily.semibold,
          fontSize: 17,
          color: p.text,
        ),
        systemOverlayStyle:
            p.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: p.border, space: 1, thickness: 1),
      iconTheme: IconThemeData(color: p.text, size: 22),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.isDark ? p.surfaceAlt : p.text,
        contentTextStyle: TextStyle(
          fontFamily: AppFontFamily.medium,
          fontSize: 13.5,
          color: p.isDark ? p.text : p.background,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: p.primary,
        inactiveTrackColor: p.surfaceAlt,
        thumbColor: p.primary,
        overlayColor: p.primary.withValues(alpha: 0.12),
        trackHeight: 3,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.onPrimary : p.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.primary : p.surfaceAlt,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.primary : p.border,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          minimumSize: const Size(0, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          textStyle: TextStyle(
            fontFamily: AppFontFamily.semibold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
