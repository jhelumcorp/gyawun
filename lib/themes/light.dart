import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontStyle = GoogleFonts.poppins();

ThemeData lightTheme({required ColorScheme colorScheme}) {
  return ThemeData.light().copyWith(
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor:
        Platform.isWindows ? Colors.transparent : colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      surfaceTintColor: Platform.isWindows ? Colors.transparent : null,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: defaultFontStyle.copyWith(color: Colors.black),
      headlineMedium: defaultFontStyle.copyWith(color: Colors.black),
      headlineSmall: defaultFontStyle.copyWith(color: Colors.black),
      bodyLarge: defaultFontStyle.copyWith(color: Colors.black),
      bodyMedium: defaultFontStyle.copyWith(color: Colors.black),
      bodySmall: defaultFontStyle.copyWith(color: Colors.black),
      displayLarge: defaultFontStyle.copyWith(color: Colors.black),
      displayMedium: defaultFontStyle.copyWith(color: Colors.black),
      displaySmall: defaultFontStyle.copyWith(color: Colors.black),
      titleLarge: defaultFontStyle.copyWith(color: Colors.black),
      titleMedium: defaultFontStyle.copyWith(color: Colors.black),
      titleSmall: defaultFontStyle.copyWith(color: Colors.black),
      labelLarge: defaultFontStyle.copyWith(color: Colors.black),
      labelMedium: defaultFontStyle.copyWith(color: Colors.black),
      labelSmall: defaultFontStyle.copyWith(color: Colors.black),
    ),
  );
}
