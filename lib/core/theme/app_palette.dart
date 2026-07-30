import 'package:flutter/material.dart';

/// The colour system for the app.
///
/// Everything the UI paints comes from one of these two palettes so that light
/// and dark mode stay in sync — never hard-code a colour in a widget.
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.primaryDeep,
    required this.primarySoft,
    required this.onPrimary,
    required this.gold,
    required this.goldSoft,
    required this.shadow,
  });

  final Brightness brightness;

  /// Page background.
  final Color background;

  /// Cards, sheets, list rows.
  final Color surface;

  /// Chips, inputs, quieter fills that sit on [surface].
  final Color surfaceAlt;

  final Color border;

  final Color text;
  final Color textMuted;
  final Color textFaint;

  /// Brand green — buttons, active states, the hero gradient.
  final Color primary;
  final Color primaryDeep;

  /// A tinted wash of [primary] for badges and selected chips.
  final Color primarySoft;
  final Color onPrimary;

  /// Accent used for ayah markers and ornaments.
  final Color gold;
  final Color goldSoft;

  final Color shadow;

  bool get isDark => brightness == Brightness.dark;

  LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [Color(0xFF10403A), Color(0xFF0C302C), Color(0xFF0B2422)]
            : const [Color(0xFF14796B), Color(0xFF0F5F55), Color(0xFF0C4A43)],
      );

  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: shadow,
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    background: Color(0xFFF5F7F6),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF3F1),
    border: Color(0xFFE2E9E6),
    text: Color(0xFF0E1B18),
    textMuted: Color(0xFF5F726D),
    textFaint: Color(0xFF93A5A0),
    primary: Color(0xFF12796B),
    primaryDeep: Color(0xFF0C4A43),
    primarySoft: Color(0xFFDFF0EC),
    onPrimary: Color(0xFFFFFFFF),
    gold: Color(0xFFB4832F),
    goldSoft: Color(0xFFF7EBD5),
    shadow: Color(0x14101B18),
  );

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0A1211),
    surface: Color(0xFF121C1A),
    surfaceAlt: Color(0xFF192523),
    border: Color(0xFF203230),
    text: Color(0xFFE8F1EE),
    textMuted: Color(0xFF9CB0AB),
    textFaint: Color(0xFF6E827D),
    primary: Color(0xFF3BBFA6),
    primaryDeep: Color(0xFF10403A),
    primarySoft: Color(0xFF16332E),
    onPrimary: Color(0xFF04201C),
    gold: Color(0xFFDCB16A),
    goldSoft: Color(0xFF2A2418),
    shadow: Color(0x40000000),
  );
}

extension PaletteContext on BuildContext {
  /// Palette matching the current theme brightness.
  AppPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
}
