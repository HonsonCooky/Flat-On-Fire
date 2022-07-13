import 'package:flutter/material.dart';

import '../_app_bucket.dart';

const double titleLargeFontSize = 30;
const double textFieldLabelSize = 22;
const double captionSize = 12;

/// Maintains static fields for Light and Dark modes
class ThemeModel {
  /// GLOBAL THEME CONSTANTS
  static final _base = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w900,
        fontFamily: "Merriweather",
      ),
      displayMedium: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        fontFamily: "Merriweather",
      ),
      displaySmall: TextStyle(
        fontSize: 26,
        fontFamily: "Merriweather",
      ),
      headlineLarge: TextStyle(
        fontSize: 10,
        fontFamily: "Ubuntu",
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
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
        fontSize: captionSize,
        fontFamily: "Ubuntu",
      ),

      /// Unspecified Buttons
      labelLarge: TextStyle(
        fontSize: 20,
        fontFamily: "Ubuntu",
      ),

      labelMedium: TextStyle(
        fontSize: 18,
        fontFamily: "Ubuntu",
        fontWeight: FontWeight.normal,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontFamily: "Ubuntu",
        fontWeight: FontWeight.normal,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(fontSize: textFieldLabelSize),
      hintStyle: TextStyle(fontSize: textFieldLabelSize),
      floatingLabelStyle: TextStyle(fontSize: textFieldLabelSize),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
      errorStyle: TextStyle(fontSize: captionSize),
      filled: true,
      alignLabelWithHint: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
            fontSize: 16,
            fontWeight: FontWeight.normal,
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
      displayLarge: _base.textTheme.displayLarge?.copyWith(color: PaletteModel.lightOnBackground),
      displayMedium: _base.textTheme.displayMedium?.copyWith(color: PaletteModel.lightOnBackground),
      displaySmall: _base.textTheme.displaySmall?.copyWith(color: PaletteModel.lightOnBackground),
      headlineLarge: _base.textTheme.headlineLarge?.copyWith(color: PaletteModel.lightOnBackground),
      headlineMedium: _base.textTheme.headlineMedium?.copyWith(color: PaletteModel.lightOnBackground),
      headlineSmall: _base.textTheme.headlineSmall?.copyWith(color: PaletteModel.lightOnBackground),
      titleLarge: _base.textTheme.titleLarge?.copyWith(color: PaletteModel.lightOnBackground),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: PaletteModel.lightOnPrimary),
      titleSmall: _base.textTheme.titleSmall?.copyWith(color: PaletteModel.lightOnBackground),
      bodyLarge: _base.textTheme.bodyLarge?.copyWith(color: PaletteModel.lightOnBackground),
      bodyMedium: _base.textTheme.bodyMedium?.copyWith(color: PaletteModel.lightOnBackground),
      bodySmall: _base.textTheme.bodySmall?.copyWith(color: PaletteModel.lightOnBackground),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: PaletteModel.lightOnPrimary),
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.lightOnPrimary),
      labelSmall: _base.textTheme.labelSmall?.copyWith(color: PaletteModel.lightOnBackground),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: PaletteModel.lightSecondary,
      selectionColor: PaletteAssistant.alpha(PaletteModel.lightPrimary, 0.4),
      selectionHandleColor: PaletteModel.lightTertiary,
    ),
    inputDecorationTheme: _base.inputDecorationTheme.copyWith(
      labelStyle: _base.inputDecorationTheme.labelStyle?.copyWith(color: PaletteModel.lightOnSurface),
      hintStyle: _base.inputDecorationTheme.hintStyle?.copyWith(color: PaletteModel.lightOnSurface),
      floatingLabelStyle: _base.inputDecorationTheme.floatingLabelStyle?.copyWith(color: PaletteModel.lightSecondary),
      focusColor: PaletteModel.lightOnBackground,
      iconColor: PaletteModel.lightOnSurface,
      fillColor: PaletteModel.lightSurface,
      errorBorder: _base.inputDecorationTheme.errorBorder?.copyWith(
        borderSide: BorderSide(color: PaletteModel.lightOnError, width: 1),
      ),
      errorStyle: _base.inputDecorationTheme.errorStyle?.copyWith(color: PaletteModel.lightOnError),
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
    dialogBackgroundColor: PaletteModel.lightSurface,
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
      displayLarge: _base.textTheme.displayLarge?.copyWith(color: PaletteModel.darkOnBackground),
      displayMedium: _base.textTheme.displayMedium?.copyWith(color: PaletteModel.darkOnBackground),
      displaySmall: _base.textTheme.displaySmall?.copyWith(color: PaletteModel.darkOnBackground),
      headlineLarge: _base.textTheme.headlineLarge?.copyWith(color: PaletteModel.darkOnBackground),
      headlineMedium: _base.textTheme.headlineMedium?.copyWith(color: PaletteModel.darkOnBackground),
      headlineSmall: _base.textTheme.headlineSmall?.copyWith(color: PaletteModel.darkOnBackground),
      titleLarge: _base.textTheme.titleLarge?.copyWith(color: PaletteModel.darkOnBackground),
      titleMedium: _base.textTheme.titleMedium?.copyWith(color: PaletteModel.darkOnPrimary),
      titleSmall: _base.textTheme.titleSmall?.copyWith(color: PaletteModel.darkOnBackground),
      bodyLarge: _base.textTheme.bodyLarge?.copyWith(color: PaletteModel.darkOnBackground),
      bodyMedium: _base.textTheme.bodyMedium?.copyWith(color: PaletteModel.darkOnBackground),
      bodySmall: _base.textTheme.bodySmall?.copyWith(color: PaletteModel.darkOnBackground),
      labelLarge: _base.textTheme.labelLarge?.copyWith(color: PaletteModel.darkOnPrimary),
      labelMedium: _base.textTheme.labelMedium?.copyWith(color: PaletteModel.darkOnPrimary),
      labelSmall: _base.textTheme.labelSmall?.copyWith(color: PaletteModel.darkOnBackground),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: PaletteModel.darkSecondary,
      selectionColor: PaletteAssistant.alpha(PaletteModel.darkPrimary, 0.4),
      selectionHandleColor: PaletteModel.darkTertiary,
    ),
    inputDecorationTheme: _base.inputDecorationTheme.copyWith(
      labelStyle: _base.inputDecorationTheme.labelStyle?.copyWith(color: PaletteModel.darkOnSurface),
      hintStyle: _base.inputDecorationTheme.hintStyle?.copyWith(color: PaletteModel.darkOnSurface),
      floatingLabelStyle: _base.inputDecorationTheme.floatingLabelStyle?.copyWith(color: PaletteModel.darkSecondary),
      focusColor: PaletteModel.darkOnBackground,
      iconColor: PaletteModel.darkOnSurface,
      fillColor: PaletteModel.darkSurface,
      errorBorder: _base.inputDecorationTheme.errorBorder?.copyWith(
        borderSide: BorderSide(color: PaletteModel.darkOnError, width: 1),
      ),
      errorStyle: _base.inputDecorationTheme.errorStyle?.copyWith(color: PaletteModel.darkOnError),
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
    textButtonTheme: TextButtonThemeData(
      style: _base.textButtonTheme.style
          ?.copyWith(foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkOnBackground)),
    ),
    dialogBackgroundColor: PaletteModel.darkSurface,
  );
}
