import 'package:flutter/material.dart';
import '../_app_bucket.dart';

const double titleLargeFontSize = 30;
const double textFieldLabelSize = 22;

class ThemeModel {
  /// GLOBAL THEME CONSTANTS
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
        fontWeight: FontWeight.w900,
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
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: "Ubuntu",
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        fontFamily: "Ubuntu",
      ),
      bodySmall: TextStyle(
        fontSize: 10,
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
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: titleLargeFontSize - 7,
        fontFamily: "Ubuntu",
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Ubuntu"),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (states) => const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Ubuntu",
          ),
        ),
      ),
    ),
  );

  /// LIGHT THEME
  static ThemeData light = _base.copyWith(
    scaffoldBackgroundColor: PaletteModel.lightBackground,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: PaletteModel.lightPrimary,
      onPrimary: PaletteModel.lightOnPrimary,
      secondary: PaletteModel.lightSecondary,
      onSecondary: PaletteModel.lightOnSecondary,
      tertiary: PaletteModel.lightTertiary,
      onTertiary: PaletteModel.lightOnTertiary,
      error: PaletteModel.lightError,
      onError: PaletteModel.lightOnError,
      background: PaletteModel.lightBackground,
      onBackground: PaletteModel.lightOnBackground,
      surface: PaletteModel.lightSurface,
      onSurface: PaletteModel.lightOnSurface,
    ),
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.lightOnPrimary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: PaletteModel.lightOnPrimary),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: PaletteModel.lightOnPrimary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: PaletteModel.lightPrimary,
      selectionColor: PaletteAssistant.alpha(PaletteModel.lightPrimary, 0.4),
      selectionHandleColor: PaletteModel.lightPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          _base.textTheme.labelMedium?.copyWith(color: PaletteModel.lightOnBackground, fontSize: textFieldLabelSize),
      floatingLabelStyle: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.lightPrimary),
      focusColor: PaletteModel.lightOnBackground,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: PaletteModel.lightOnBackground)),
      iconColor: PaletteModel.lightOnBackground,
      isDense: true,
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: PaletteModel.lightSecondary)),
      labelColor: PaletteModel.lightOnPrimary,
      unselectedLabelColor: PaletteAssistant.alpha(PaletteModel.lightOnPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _base.elevatedButtonTheme.style?.copyWith(
          overlayColor:
              MaterialStateProperty.resolveWith((states) => PaletteAssistant.alpha(PaletteModel.lightOnSecondary, 0.3)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.lightOnSecondary),
          backgroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.lightSecondary)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _base.textButtonTheme.style
          ?.copyWith(foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.lightOnBackground)),
    ),
  );

  /// DARK THEME
  static ThemeData dark = _base.copyWith(
    scaffoldBackgroundColor: PaletteModel.darkBackground,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: PaletteModel.darkPrimary,
      onPrimary: PaletteModel.darkOnPrimary,
      secondary: PaletteModel.darkSecondary,
      onSecondary: PaletteModel.darkOnSecondary,
      secondaryContainer: PaletteModel.darkSecondary,
      tertiary: PaletteModel.darkTertiary,
      onTertiary: PaletteModel.darkOnTertiary,
      tertiaryContainer: PaletteModel.darkTertiary,
      error: PaletteModel.darkError,
      onError: PaletteModel.darkOnError,
      background: PaletteModel.darkBackground,
      onBackground: PaletteModel.darkOnBackground,
      surface: PaletteModel.darkSurface,
      onSurface: PaletteModel.darkOnSurface,
    ),
    textTheme: _base.textTheme.copyWith(
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.darkOnPrimary),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: PaletteModel.darkOnPrimary),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: PaletteModel.darkOnPrimary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: PaletteModel.darkSecondary,
      selectionColor: PaletteAssistant.alpha(PaletteModel.darkSecondary, 0.4),
      selectionHandleColor: PaletteModel.darkSecondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          _base.textTheme.labelMedium?.copyWith(color: PaletteModel.darkOnBackground, fontSize: textFieldLabelSize),
      floatingLabelStyle: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.darkSecondary),
      focusColor: PaletteModel.darkOnBackground,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: PaletteModel.darkOnBackground)),
      iconColor: PaletteModel.darkOnBackground,
      isDense: true,
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: PaletteModel.darkSecondary)),
      labelColor: PaletteModel.darkOnPrimary,
      unselectedLabelColor: PaletteAssistant.alpha(PaletteModel.darkOnPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _base.elevatedButtonTheme.style?.copyWith(
          overlayColor:
              MaterialStateProperty.resolveWith((states) => PaletteAssistant.alpha(PaletteModel.darkOnSecondary, 0.3)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkOnSecondary),
          backgroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkSecondary)),
    ),
  );
}
