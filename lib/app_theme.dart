import 'package:flutter/material.dart';

/* -------------------------------------------------------------------------- */
/*                            App Theme Constants                               */
/* -------------------------------------------------------------------------- */
class AppTheme {
  /* -------------------------------------------------------------------------- */
  /*                            Color Definitions                                 */
  /* -------------------------------------------------------------------------- */
  static const Color primary = Color(0xFF5D9CEC);
  static const Color backgroundLight = Color(0xFFDFECDB);
  static const Color backgroundDark = Color(0xFF060E1E);
  static const Color green = Color(0xFF61E757);
  static const Color red = Color(0xFFEC4B4B);
  static const Color grey = Color(0xFFC8C9CB);
  static const Color black = Color(0xFF060E1E);
  static const Color white = Color(0xFFFFFFFF);

  /* -------------------------------------------------------------------------- */
  /*                            Light Theme Configuration                         */
  /* -------------------------------------------------------------------------- */
  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: backgroundLight,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      selectedItemColor: primary,
      unselectedItemColor: grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          color: white,
          width: 4,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: white,
        ),
      ),
    ),
  );

  /* -------------------------------------------------------------------------- */
  /*                            Dark Theme Configuration                          */
  /* -------------------------------------------------------------------------- */
  static ThemeData darkTheme = ThemeData(
    primaryColor: backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: backgroundDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundDark,
      selectedItemColor: primary,
      unselectedItemColor: white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          color: white,
          width: 4,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white, // Changed from black to white
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: white, // Changed from black to white
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: white,
        ),
      ),
    ),
  );
}
