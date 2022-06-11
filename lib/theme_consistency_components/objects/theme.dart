import 'package:flat_on_fire/theme_consistency_components/objects/fof_custom_colors.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData light() {
    return ThemeData().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        FofCustomColors(
          grey: Colors.grey,
          background: const Color(0xffe8e5e0),
          primary: const Color(0xffe94174),
          accent: const Color(0xffdead5c),
          counterPrimary: const Color(0xff383e64),
          googleBlue: const Color(0xff4285F4),
          success: const Color(0xff57e941),
          error: const Color(0xffe94f41),
          disabled: const Color(0x55e94f41),
        )
      ],
    );
  }

  // bd93f9
  // 8be9fd
  // 50fa7b
  // ff79c6
  static ThemeData dark() {
    return ThemeData.dark();
  }
}
