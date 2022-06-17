import 'package:flutter/material.dart';

import 'color_handler.dart';

class AppTheme {
  static final _base = ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w900,
        fontFamily: "Raleway",
      ),
      headline2: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w900,
        fontFamily: "Raleway",
      ),
      headline3: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        fontFamily: "Raleway",
      ),
      labelMedium: TextStyle(
        fontSize: 20
      ),
      button: TextStyle(
        fontSize: 18
      ),
      subtitle1: TextStyle(
        fontSize: 22
      ),
    ),
  );

  static ThemeData light = _base.copyWith(
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightTextLight,
      primaryContainer: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightTextDark,
      secondaryContainer: AppColors.lightSecondary,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightTextLight,
      tertiaryContainer: AppColors.lightTertiary,
      error: AppColors.lightError,
      onError: AppColors.lightTextLight,
      background: AppColors.lightBackground,
      onBackground: AppColors.lightTextDark,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightTextDark,
    ),
    hintColor: AppColors.lightTextDark,
    inputDecorationTheme: InputDecorationTheme(
      alignLabelWithHint: true,
      isDense: true,
      labelStyle: TextStyle(color: AppColors.lightTextDark, fontSize: _base.textTheme.labelMedium?.fontSize),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.lightTextDark),
      ),
    ),
  );

  static ThemeData dark = _base.copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkTextLight,
      primaryContainer: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkTextDark,
      secondaryContainer: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkTextDark,
      tertiaryContainer: AppColors.darkTertiary,
      error: AppColors.darkError,
      onError: AppColors.darkTextDark,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkTextLight,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkTextDark,
    ),
    hintColor: AppColors.darkSecondary,
  );
}
