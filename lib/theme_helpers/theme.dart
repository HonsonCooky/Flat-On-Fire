import 'package:flutter/material.dart';

import 'color_handler.dart';

const double titleLargeFontSize = 32;
class AppTheme {
  static final _base = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w900,
        fontFamily: "Roboto",
      ),
      displayMedium: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        fontFamily: "Roboto",
      ),
      displaySmall: TextStyle(
        fontSize: 26,
        fontFamily: "Roboto",
      ),
      headlineMedium: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      headlineSmall: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),

      /// Tab Bar
      titleLarge: TextStyle(
        fontSize: titleLargeFontSize,
        fontFamily: "Ubuntu",
      ),

      /// Text Field
      titleMedium: TextStyle(
        fontSize: 20,
        fontFamily: "Ubuntu",
      ),
      titleSmall: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      bodyLarge: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      bodyMedium: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),

      /// Elevated Buttons
      labelLarge: TextStyle(
        fontSize: 24,
        fontFamily: "Ubuntu",
      ),
      labelMedium: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(
        fontSize: titleLargeFontSize,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: titleLargeFontSize - 10,
      ),
    ),
  );

  static ThemeData light = _base.copyWith(
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      background: AppColors.lightBackground,
      onBackground: AppColors.lightOnBackground,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
    ),
    hintColor: AppColors.lightOnSurface,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.lightOnSurface,
        selectionColor: ColorAlter.alpha(AppColors.lightPrimary, 0.4),
        selectionHandleColor: AppColors.lightSecondary),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOnSurface)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOnSurface)),
      iconColor: AppColors.lightOnSurface,
      isDense: true,
    ),
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: AppColors.lightTertiary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: AppColors.lightOnSurface),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: AppColors.lightOnSurface),
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 5.0, color: AppColors.lightSecondary),
      ),
    ),
  );

  static ThemeData dark = _base.copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiary,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkOnBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
    ),
    hintColor: AppColors.darkOnSurface,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.darkOnSurface,
        selectionColor: ColorAlter.alpha(AppColors.darkPrimary, 0.4),
        selectionHandleColor: AppColors.darkSecondary),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.darkOnSurface)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.darkOnSurface)),
      iconColor: AppColors.darkOnSurface,
      isDense: true,
    ),
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: AppColors.darkTertiary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: AppColors.darkOnSurface),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: AppColors.darkOnSurface),
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 5.0, color: AppColors.darkSecondary),
      ),
    ),
  );
}
