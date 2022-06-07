import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData light() {
    return ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: const Color(0xffe94174),
      secondaryHeaderColor: const Color(0xffdead5c),
      scaffoldBackgroundColor: const Color(0xffe8e5e0),
      cardColor: const Color(0xffe8e5e0),
      dividerColor: const Color(0xff383e64),
      errorColor: const Color(0xffe94f41),
      iconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      disabledColor: const Color(0x55e94f41),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff383e64),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Color(0xff383e64),
        foregroundColor: Color(0xffe8e5e0),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0x96383e64),
        elevation: 0,
        contentTextStyle: TextStyle(
          color: Color(0xffe8e5e0),
          fontSize: 15,
        ),
        behavior: SnackBarBehavior.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
            if (states.any((element) => element == MaterialState.pressed)) {
              return 1;
            } else {
              return 5;
            }
          }),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) => const StadiumBorder()),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) => const Color(0x22e8e5e0)),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => const Color(0xffe94174)),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => const Color(0xffe8e5e0)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) => const Color(0x22e94174)),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((Set<MaterialState> states) => const StadiumBorder()),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => const Color(0xffe94174)),
        ),
      ),
      textTheme: GoogleFonts.getTextTheme(
          "Roboto Slab",
          const TextTheme(
            headline1: TextStyle(color: Color(0xffe8e5e0), fontSize: 40, fontWeight: FontWeight.bold),
            headline2: TextStyle(color: Color(0xff383e64), fontSize: 40, fontWeight: FontWeight.bold),
            headline3: TextStyle(color: Color(0xffe8e5e0), fontSize: 30, fontWeight: FontWeight.bold),
            headline4: TextStyle(color: Color(0xff383e64), fontSize: 35, fontWeight: FontWeight.bold),
            headline5: TextStyle(color: Color(0xff383e64), fontSize: 30),
            headline6: TextStyle(color: Color(0xff383e64), fontWeight: FontWeight.bold),
            overline: TextStyle(
              color: Color(0xff383e64),
            ),
            subtitle1: TextStyle(
              color: Color(0xff383e64),
              fontSize: 20,
            ),
            subtitle2: TextStyle(
              color: Color(0xff383e64),
              fontSize: 15,
            ),
            bodyText1: TextStyle(
              color: Color(0xff383e64),
            ),
            bodyText2: TextStyle(
              color: Color(0xffe8e5e0),
            ),
            button: TextStyle(
              fontSize: 20,
            ),
            caption: TextStyle(
              fontSize: 12,
              color: Color(0xff383e64),
            ),
            labelMedium: TextStyle(
              fontSize: 18,
              color: Color(0xff383e64),
            ),
          )),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark();
  }
}
