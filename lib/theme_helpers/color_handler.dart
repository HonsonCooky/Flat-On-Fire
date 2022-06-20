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
  static Color lightBackground = const Color(0xffDFDCE3);
  static Color lightPrimary = const Color(0xffF7B733);
  static Color lightSecondary = const Color(0xffFC4A1A);
  static Color lightTertiary = const Color(0xff4ABDAC);
  static Color lightError = const Color(0xffe94f41);
  static Color lightSurface = const Color(0xffc2bfbc);

  // LIGHT ON
  static Color lightOnBackground = const Color(0xcc000000);
  static Color lightOnPrimary = const Color(0xcc000000);
  static Color lightOnSecondary = const Color(0xccffffff);
  static Color lightOnTertiary = const Color(0xcc000000);
  static Color lightOnError = const Color(0xcc000000);
  static Color lightOnSurface = const Color(0xcc000000);

  // DARK
  static Color darkBackground = const Color(0xff282a36);
  static Color darkPrimary = const Color(0xff44475a);
  static Color darkSecondary = const Color(0xffbd93f9);
  static Color darkTertiary = const Color(0xffbd93f9);
  static Color darkError = const Color(0xffff5555);
  static Color darkSurface = const Color(0xff8be9fd);

  // DARK ON
  static Color darkOnBackground = const Color(0xccf8f8f2);
  static Color darkOnPrimary = const Color(0xccf8f8f2);
  static Color darkOnSecondary = const Color(0xcc282a36);
  static Color darkOnTertiary = const Color(0xcc282a36);
  static Color darkOnError = const Color(0xcc282a36);
  static Color darkOnSurface = const Color(0xccf8f8f2);

  // CONSTANT
  static Color googleBlue = const Color(0xff4285F4);
}
