import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorApp.linenWhite,
    brightness: Brightness.light,
    primary: ColorApp.primary,
  ),
  scaffoldBackgroundColor: ColorApp.linenWhite,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 24),
    titleMedium: TextStyle(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontStyle: FontStyle.normal, fontSize: 18, fontWeight: FontWeight.w300),
    bodyLarge: TextStyle(
      fontStyle: FontStyle.normal,
      color: ColorApp.pureWhite,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 14,
      color: ColorApp.secondary,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    labelLarge: TextStyle(
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: ColorApp.primary),
  iconTheme: const IconThemeData(color: Colors.black, size: 24),
  primaryIconTheme: const IconThemeData(color: ColorApp.primary, size: 24),
  checkboxTheme: const CheckboxThemeData(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
);
