import 'package:flutter/material.dart';

/// Handel Color Alterations
class ColorAlter {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color alpha(Color color, [double decPercent = .5]) {
    assert(decPercent >= 0 && decPercent <= 1);
    return color.withAlpha((256 * decPercent.clamp(0.0, 1.0)).round());
  }
}

/// All potential app colors in one place
class AppColors {
  // LIGHT
  static Color lightBackground = const Color(0xffe8e5e0);
  static Color lightPrimary = const Color(0xffdead5c);
  static Color lightSecondary = const Color(0xffe94174);
  static Color lightTertiary = const Color(0xff383e64);
  static Color lightCard = const Color(0xffc2bfbc);
  static Color lightSuccess = const Color(0xff57e941);
  static Color lightError = const Color(0xffe94f41);
  static Color lightDisabled = const Color(0xffc2bfbc);
  static Color lightTextLight = const Color(0xffe8e5e0);
  static Color lightTextDark = const Color(0xff383e64);

  // DARK
  static Color darkBackground = const Color(0xff282a36);
  static Color darkPrimary = const Color(0xffff79c6);
  static Color darkSecondary = const Color(0xffffb86c);
  static Color darkTertiary = const Color(0xfff8f8f2);
  static Color darkCard = const Color(0xff8be9fd);
  static Color darkSuccess = const Color(0xff50fa7b);
  static Color darkError = const Color(0xffff5555);
  static Color darkDisabled = const Color(0xff3f4256);
  static Color darkTextLight = const Color(0xfff8f8f2);
  static Color darkTextDark = const Color(0xff282a36);

  // CONSTANT
  static Color googleBlue = const Color(0xff4285F4);
}
