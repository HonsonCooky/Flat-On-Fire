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
        fontSize: 30,
        fontFamily: "Ubuntu",
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontFamily: "Ubuntu",
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
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
    cardTheme: const CardTheme(
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(fontSize: textFieldLabelSize),
      hintStyle: TextStyle(fontSize: textFieldLabelSize),
      floatingLabelStyle: TextStyle(fontSize: textFieldLabelSize, fontWeight: FontWeight.w600),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 2)),
      errorStyle: TextStyle(fontSize: captionSize),
      filled: true,
      alignLabelWithHint: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
    switchTheme: const SwitchThemeData(),
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
    cardTheme: _base.cardTheme.copyWith(color: PaletteModel.lightSurface),
    textTheme: _base.textTheme.copyWith(
      displayLarge: _base.textTheme.displayLarge?.copyWith(color: PaletteModel.lightOnBackground),
      displayMedium: _base.textTheme.displayMedium?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnBackground),
      ),
      displaySmall: _base.textTheme.displaySmall?.copyWith(color: PaletteModel.lightOnBackground),
      headlineLarge: _base.textTheme.headlineLarge?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnBackground),
      ),
      headlineMedium: _base.textTheme.headlineMedium?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnBackground),
      ),
      headlineSmall: _base.textTheme.headlineSmall?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnBackground),
      ),
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
    splashColor: PaletteModel.lightTertiary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: PaletteModel.lightSecondary,
      selectionColor: PaletteAssistant.alpha(PaletteModel.lightPrimary, 0.4),
      selectionHandleColor: PaletteModel.lightTertiary,
    ),
    inputDecorationTheme: _base.inputDecorationTheme.copyWith(
      labelStyle: _base.inputDecorationTheme.hintStyle?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnSurface),
      ),
      hintStyle: _base.inputDecorationTheme.hintStyle?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.lightOnSurface),
      ),
      floatingLabelStyle: _base.inputDecorationTheme.floatingLabelStyle?.copyWith(color: PaletteModel.lightOnSurface),
      focusColor: PaletteModel.lightOnBackground,
      iconColor: PaletteModel.lightOnSurface,
      fillColor: PaletteModel.lightSurface,
      errorBorder: _base.inputDecorationTheme.errorBorder?.copyWith(
        borderSide: _base.inputDecorationTheme.focusedBorder?.borderSide.copyWith(color: PaletteModel.lightOnError),
      ),
      focusedBorder: _base.inputDecorationTheme.focusedBorder?.copyWith(
        borderSide: _base.inputDecorationTheme.focusedBorder?.borderSide.copyWith(color: PaletteModel.lightTertiary),
      ),
      errorStyle: _base.inputDecorationTheme.errorStyle?.copyWith(color: PaletteModel.lightOnError),
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      labelColor: PaletteModel.lightOnSecondary,
      unselectedLabelColor: PaletteModel.lightOnPrimary,
      indicator: (_base.tabBarTheme.indicator as BoxDecoration).copyWith(
        color: PaletteModel.lightSecondary,
      ),
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
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return PaletteModel.lightSurface;
        }
        if (states.contains(MaterialState.selected)){
          return PaletteModel.lightTertiary;
        }
        return PaletteModel.lightSecondary;
      }),
      trackColor:  MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return PaletteAssistant.darken(PaletteModel.lightSurface);
        }
        if (states.contains(MaterialState.selected)){
          return PaletteAssistant.alpha(PaletteModel.lightTertiary);
        }
        return PaletteAssistant.alpha(PaletteModel.lightSecondary);
      }),
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
    cardTheme: _base.cardTheme.copyWith(color: PaletteModel.darkSurface),
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
      labelStyle: _base.inputDecorationTheme.hintStyle?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.darkOnSurface),
      ),
      hintStyle: _base.inputDecorationTheme.hintStyle?.copyWith(
        color: PaletteAssistant.alpha(PaletteModel.darkOnSurface),
      ),
      floatingLabelStyle: _base.inputDecorationTheme.hintStyle?.copyWith(color: PaletteModel.darkOnSurface),
      focusColor: PaletteModel.darkOnBackground,
      iconColor: PaletteModel.darkOnSurface,
      fillColor: PaletteModel.darkSurface,
      errorBorder: _base.inputDecorationTheme.errorBorder?.copyWith(
        borderSide: _base.inputDecorationTheme.focusedBorder?.borderSide.copyWith(color: PaletteModel.darkOnError),
      ),
      focusedBorder: _base.inputDecorationTheme.focusedBorder?.copyWith(
        borderSide: _base.inputDecorationTheme.focusedBorder?.borderSide.copyWith(color: PaletteModel.darkTertiary),
      ),
      errorStyle: _base.inputDecorationTheme.errorStyle?.copyWith(color: PaletteModel.darkOnError),
    ),
    tabBarTheme: _base.tabBarTheme.copyWith(
      labelColor: PaletteModel.darkOnSecondary,
      unselectedLabelColor: PaletteModel.darkOnPrimary,
      indicator: (_base.tabBarTheme.indicator as BoxDecoration).copyWith(
        color: PaletteModel.darkSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _base.elevatedButtonTheme.style?.copyWith(
          overlayColor:
              MaterialStateProperty.resolveWith((states) => PaletteAssistant.alpha(PaletteModel.darkOnSecondary, 0.3)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkOnSecondary),
          backgroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkSecondary)),
    ),
    splashColor: PaletteModel.darkTertiary,
    textButtonTheme: TextButtonThemeData(
      style: _base.textButtonTheme.style
          ?.copyWith(foregroundColor: MaterialStateProperty.resolveWith((states) => PaletteModel.darkOnBackground)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return PaletteModel.darkSurface;
        }
        if (states.contains(MaterialState.selected)){
          return PaletteModel.darkTertiary;
        }
        return PaletteModel.darkSecondary;
      }),
      trackColor:  MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return PaletteAssistant.lighten(PaletteModel.darkSurface);
        }
        if (states.contains(MaterialState.selected)){
          return PaletteAssistant.alpha(PaletteModel.darkTertiary);
        }
        return PaletteAssistant.alpha(PaletteModel.darkSecondary);
      }),
    ),
    dialogBackgroundColor: PaletteModel.darkSurface,
  );
}
