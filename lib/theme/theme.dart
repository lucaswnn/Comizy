import 'package:flutter/material.dart';

// cores do App definidas aqui
class AppColors {
  static const brightness = Brightness.light;
  static const primary = Color.fromARGB(255, 11, 71, 136);
  static const secondary = Color.fromARGB(255, 232, 65, 76);
  static const tertiary = Color.fromARGB(255, 85, 127, 172);
  static const lightNeutral = Colors.white;
  static const mediumNeutral = Colors.grey;
  static const darkNeutral = Colors.black;
  static const shadow = Colors.grey;
  static const defaultTextColor = Colors.black;
  static const alternativeTextColor = primary;
  static const whiteTextColor = Colors.white;
}

class AppText {
  static const defaultTextHeight = 15.0;
  static const emphasisTextHeight = 20.0;

  static const onDarkBackgroundTextStyle = TextStyle(
    color: AppColors.whiteTextColor,
    fontSize: defaultTextHeight,
  );

  static const defaultTextStyle = TextStyle(
    color: AppColors.defaultTextColor,
    fontSize: defaultTextHeight,
  );

  static const alternativeTextStyle = TextStyle(
    color: AppColors.alternativeTextColor,
    fontSize: defaultTextHeight,
  );
}

class AppAppearance {
  static const defaultRoundedBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );

  static const buttonRoundedBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
  );

  static const appBarElevation = 4.0;
  static const cardElevation = 5.0;
}

class AppThemeData {
  // tema padrão do app
  ElevatedButtonThemeData _appElevatedButtonTheme() =>
      const ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(AppColors.primary),
          foregroundColor:
              MaterialStatePropertyAll<Color>(AppColors.lightNeutral),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              AppAppearance.buttonRoundedBorder),
        ),
      );

  TextButtonThemeData _appTextButtonTheme() => const TextButtonThemeData(
      style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent),
          textStyle: MaterialStatePropertyAll<TextStyle>(
              TextStyle(decoration: TextDecoration.underline)),
          padding:
              MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero)));

  UnderlineInputBorder _buildBorder(Color color) =>
      UnderlineInputBorder(borderSide: BorderSide(color: color));

  InputDecorationTheme _appInputDecorationTheme() => InputDecorationTheme(
        focusedBorder: _buildBorder(AppColors.secondary),
        enabledBorder: _buildBorder(AppColors.mediumNeutral),
        border: _buildBorder(AppColors.darkNeutral),
        hintStyle: const TextStyle(color: AppColors.tertiary),
      );

  ColorScheme _appColorScheme() => const ColorScheme(
        brightness: AppColors.brightness,
        primary: AppColors.primary,
        onPrimary: AppColors.lightNeutral,
        secondary: AppColors.secondary,
        onSecondary: AppColors.lightNeutral,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.lightNeutral,
        error: AppColors.darkNeutral,
        onError: AppColors.lightNeutral,
        background: AppColors.lightNeutral,
        onBackground: AppColors.primary,
        surface: AppColors.tertiary,
        onSurface: AppColors.lightNeutral,
      );

  AppBarTheme _appBarTheme() => const AppBarTheme(
        backgroundColor: AppColors.tertiary,
        foregroundColor: AppColors.lightNeutral,
        elevation: AppAppearance.appBarElevation,
        shadowColor: AppColors.shadow,
      );

  ListTileThemeData _appListTileTheme() => const ListTileThemeData(
        shape: AppAppearance.defaultRoundedBorder,
      );

  CardTheme _appCardTheme() => const CardTheme(
        color: AppColors.tertiary,
        shadowColor: AppColors.shadow,
        elevation: AppAppearance.cardElevation,
      );

  TextTheme _appTextTheme() => const TextTheme(
        bodyMedium: AppText.defaultTextStyle,
      );

  IconThemeData _iconTheme() =>
      const IconThemeData(size: 30, color: AppColors.primary);

  ThemeData appThemeData() {
    return ThemeData(
      useMaterial3: true,
      textTheme: _appTextTheme(),
      colorScheme: _appColorScheme(),
      appBarTheme: _appBarTheme(),
      listTileTheme: _appListTileTheme(),
      cardTheme: _appCardTheme(),
      elevatedButtonTheme: _appElevatedButtonTheme(),
      inputDecorationTheme: _appInputDecorationTheme(),
      textButtonTheme: _appTextButtonTheme(),
      iconTheme: _iconTheme(),
    );
  }
}
