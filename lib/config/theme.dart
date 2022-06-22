import 'package:flutter/material.dart';

import '_configuration.dart';

const double titleLargeFontSize = 30;
const double textFieldLabelSize = 22;

class AppTheme {
  static final _base = ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w900,
          fontFamily: "Ubuntu",
        ),
        displayMedium: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          fontFamily: "Ubuntu",
        ),
        displaySmall: TextStyle(
          fontSize: 26,
          fontFamily: "Ubuntu",
        ),
        headlineLarge: TextStyle(
          fontSize: 10,
          fontFamily: "Ubuntu",
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
        ),

        /// Text Field Contents
        titleMedium: TextStyle(
          fontSize: 20,
          fontFamily: "Ubuntu",
        ),
        titleSmall: TextStyle(
          fontSize: 10,
          fontFamily: "Ubuntu",
        ),
        bodyLarge: TextStyle(fontSize: 16, fontFamily: "Ubuntu", fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
          fontSize: 12,
          fontFamily: "Ubuntu",
        ),
        bodySmall: TextStyle(
          fontSize: 8,
          fontFamily: "Ubuntu",
        ),

        /// Unspecified Buttons
        labelLarge: TextStyle(
          fontSize: 16,
          fontFamily: "Ubuntu",
        ),

        labelMedium: TextStyle(
          fontSize: 20,
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
          fontFamily: "Ubuntu",
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: titleLargeFontSize - 10,
          fontFamily: "Ubuntu",
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
      )));

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
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: AppColors.lightOnPrimary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: AppColors.lightOnPrimary),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: AppColors.lightOnPrimary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.lightPrimary,
      selectionColor: PaletteAssistant.alpha(AppColors.lightPrimary, 0.4),
      selectionHandleColor: AppColors.lightPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          _base.textTheme.labelMedium?.copyWith(color: AppColors.lightOnBackground, fontSize: textFieldLabelSize),
      floatingLabelStyle: _base.textTheme.labelMedium?.copyWith(color: AppColors.lightPrimary),
      focusColor: AppColors.lightOnBackground,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOnBackground)),
      iconColor: AppColors.lightOnBackground,
      isDense: true,
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: AppColors.lightSecondary)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _base.elevatedButtonTheme.style?.copyWith(
          overlayColor:
              MaterialStateProperty.resolveWith((states) => PaletteAssistant.alpha(AppColors.lightOnSecondary, 0.3)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.lightOnSecondary),
          backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.lightSecondary)),
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
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: AppColors.darkOnPrimary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: AppColors.darkOnPrimary),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: AppColors.darkOnPrimary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.darkSecondary,
      selectionColor: PaletteAssistant.alpha(AppColors.darkSecondary, 0.4),
      selectionHandleColor: AppColors.darkSecondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          _base.textTheme.labelMedium?.copyWith(color: AppColors.darkOnBackground, fontSize: textFieldLabelSize),
      floatingLabelStyle: _base.textTheme.labelMedium?.copyWith(color: AppColors.darkSecondary),
      focusColor: AppColors.darkOnBackground,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.darkOnBackground)),
      iconColor: AppColors.darkOnBackground,
      isDense: true,
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: AppColors.darkSecondary)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _base.elevatedButtonTheme.style?.copyWith(
          overlayColor:
              MaterialStateProperty.resolveWith((states) => PaletteAssistant.alpha(AppColors.darkOnSecondary, 0.3)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.darkOnSecondary),
          backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.darkSecondary)),
    ),
  );
}
