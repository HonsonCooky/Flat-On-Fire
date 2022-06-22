import 'package:flutter/material.dart';

class PaletteAssistant {
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
