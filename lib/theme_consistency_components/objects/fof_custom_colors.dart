import 'package:flutter/material.dart';

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

/// Custom Colors provided globally through a ThemeExtension (allowing for custom key value pairs)
class FofCustomColors extends ThemeExtension<FofCustomColors> {
  final Color grey;
  final Color background;
  final Color primary;
  final Color accent;
  final Color counterPrimary;
  final Color success;
  final Color error;
  final Color googleBlue;
  final Color disabled;

  FofCustomColors(
      {required this.grey,
      required this.background,
      required this.primary,
      required this.accent,
      required this.counterPrimary,
      required this.success,
      required this.error,
      required this.googleBlue,
      required this.disabled});

  FofCustomColors factory(FofCustomColors colors) => FofCustomColors(
      grey: colors.grey,
      background: colors.background,
      primary: colors.primary,
      accent: colors.accent,
      counterPrimary: colors.counterPrimary,
      success: colors.success,
      error: colors.error,
      googleBlue: colors.googleBlue,
      disabled: colors.disabled);

  @override
  ThemeExtension<FofCustomColors> copyWith({
    Color? grey,
    Color? background,
    Color? primary,
    Color? accent,
    Color? counterPrimary,
    Color? success,
    Color? error,
    Color? googleBlue,
    Color? disabled,
  }) {
    return FofCustomColors(
        grey: grey ?? this.grey,
        background: background ?? this.background,
        primary: primary ?? this.primary,
        accent: accent ?? this.accent,
        counterPrimary: counterPrimary ?? this.counterPrimary,
        success: success ?? this.success,
        error: error ?? this.error,
        googleBlue: googleBlue ?? this.googleBlue,
        disabled: disabled ?? this.disabled);
  }

  @override
  ThemeExtension<FofCustomColors> lerp(ThemeExtension<FofCustomColors>? other, double t) {
    if (other is! FofCustomColors) {
      return this;
    }
    return factory(other);
  }
}
