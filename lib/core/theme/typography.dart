import 'package:flutter/material.dart';

TextTheme appTextTheme(TextTheme? textTheme) {
  textTheme ??= ThemeData.light().textTheme;

  return TextTheme(
    displayLarge: TextStyle(
      color: textTheme.displayLarge?.color,
      fontWeight: FontWeight.normal,
      fontSize: 57,
      height: 64 / 57,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      color: textTheme.displayMedium?.color,
      fontWeight: FontWeight.normal,
      fontSize: 45,
      height: 52 / 45,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      color: textTheme.displaySmall?.color,
      fontWeight: FontWeight.normal,
      fontSize: 36,
      height: 44 / 36,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      color: textTheme.headlineLarge?.color,
      fontWeight: FontWeight.normal,
      fontSize: 32,
      height: 40 / 32,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      color: textTheme.headlineMedium?.color,
      fontWeight: FontWeight.normal,
      fontSize: 28,
      height: 36 / 28,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      color: textTheme.headlineSmall?.color,
      fontWeight: FontWeight.normal,
      fontSize: 24,
      height: 32 / 24,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      color: textTheme.titleLarge?.color,
      fontWeight: FontWeight.normal, // M3 uses normal, M2 used w500
      fontSize: 22,
      height: 28 / 22,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      color: textTheme.titleMedium?.color,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      color: textTheme.titleSmall?.color,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      color: textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.5, // M3 uses 0.5, M2 used 0.15
    ),
    bodyMedium: TextStyle(
      color: textTheme.bodyMedium?.color,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: textTheme.bodySmall?.color,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: textTheme.labelLarge?.color?.withAlpha(200),
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      color: textTheme.labelMedium?.color?.withAlpha(200),
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: textTheme.labelSmall?.color?.withAlpha(200),
      fontWeight: FontWeight.w500,
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.5,
    ),
  );
}
