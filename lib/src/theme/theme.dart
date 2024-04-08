import 'package:flutter/material.dart';

class MainThemeData {
  static ThemeData mainThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromARGB(255, 7, 21, 145),
        onPrimary: Colors.white,
        secondary: Color.fromARGB(255, 255, 17, 0),
        onSecondary: Colors.white,
        error: Colors.purple,
        onError: Colors.white,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Color.fromARGB(255, 219, 219, 219),
        onSurface: Colors.black),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 70, 70),
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey,
    ),
  );
}
