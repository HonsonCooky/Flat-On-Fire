import 'package:flutter/material.dart';

import 'color_handler.dart';

class AppTheme {
  static final _base = ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  ));

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
        onTertiary: AppColors.lightTextDark,
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
        labelStyle: TextStyle(color: AppColors.lightTextDark),
        focusColor: AppColors.lightTextDark,
        isDense: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightTertiary,
        foregroundColor: AppColors.lightBackground,
      ));

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
