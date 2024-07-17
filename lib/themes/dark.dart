import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ColorScheme.fromSeed(
//             seedColor: accentColor,
//             brightness: darkScheme.brightness,
//             primary: accentColor,
//             primaryContainer: accentColor,
//             onPrimaryContainer: Colors.black,
//             surface: accentColor.withAlpha(10),
//           )
final defaultFontStyle = GoogleFonts.poppins();
ColorScheme darkScheme = const ColorScheme.dark();
ThemeData darkTheme({required ColorScheme colorScheme}) {
  return ThemeData.dark().copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor:
        Platform.isWindows ? Colors.transparent : colorScheme.surface,
    primaryColor: colorScheme.primary,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Platform.isWindows ? Colors.transparent : null,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: defaultFontStyle.copyWith(color: Colors.white),
      headlineMedium: defaultFontStyle.copyWith(color: Colors.white),
      headlineSmall: defaultFontStyle.copyWith(color: Colors.white),
      bodyLarge: defaultFontStyle.copyWith(color: Colors.white),
      bodyMedium: defaultFontStyle.copyWith(color: Colors.white),
      bodySmall: defaultFontStyle.copyWith(color: Colors.white),
      displayLarge: defaultFontStyle.copyWith(color: Colors.white),
      displayMedium: defaultFontStyle.copyWith(color: Colors.white),
      displaySmall: defaultFontStyle.copyWith(color: Colors.white),
      titleLarge: defaultFontStyle.copyWith(color: Colors.white),
      titleMedium: defaultFontStyle.copyWith(color: Colors.white),
      titleSmall: defaultFontStyle.copyWith(color: Colors.white),
      labelLarge: defaultFontStyle.copyWith(color: Colors.white),
      labelMedium: defaultFontStyle.copyWith(color: Colors.white),
      labelSmall: defaultFontStyle.copyWith(color: Colors.white),
    ),
  );
}
