import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // Solid colors used in the gradient (handy to reuse individually too)
  static const Color darkRedTop = Color(0xFF2C060F);
  static const Color darkRedMid = Color(0xFF490A15);
  static const Color darkRedBottom = Color(0xFF23080D);

  // Gradient — CSS 179.36deg is essentially top-to-bottom (180deg = topCenter -> bottomCenter)
  static const LinearGradient backgroundColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkRedTop, darkRedMid, darkRedBottom],
    stops: [
      0.0,
      0.596,
      1.0
    ], // approx position of -17.86%, 43.46%, 106.27% remapped to 0–1
  );

  static const Color goldTan = Color(0xFFEAC17B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color maroon = Color(0xFF4B1219);

  static const Color goldGradientTop = Color(0xFFEFC882);
  static const Color goldGradientBottom = Color(0xFFE0A543);
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldGradientTop, goldGradientBottom],
  );

  static const Color brownGradientTop = Color(0xFF4E131A);
  static const Color brownGradientBottom = Color(0xFF350B11);
  static const LinearGradient brownGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brownGradientTop, brownGradientBottom],
  );
}

class AppShadows {
  AppShadows._();

  // box-shadow: 1px 1px 3px 0px rgba(106, 106, 106, 1)
  static const BoxShadow softGreyShadow = BoxShadow(
    color: Color(0xFF6A6A6A),
    offset: Offset(1, 1),
    blurRadius: 3,
    spreadRadius: 0,
  );

  // box-shadow: 0px -3px 7px 0px rgba(0, 0, 0, 0.4)
  static const BoxShadow topBlackShadow = BoxShadow(
    color: Color(0x66000000), // 0.4 opacity ≈ 0x66
    offset: Offset(0, -3),
    blurRadius: 7,
    spreadRadius: 0,
  );
}
