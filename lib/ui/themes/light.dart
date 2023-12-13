import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontStyle = GoogleFonts.poppins();

ThemeData lightTheme(accentColor) => ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: accentColor),
    primaryColor: accentColor,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
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
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: accentColor,
        ),
        fillColor: Colors.grey[100]),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.grey[200],
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
    ),
    textSelectionTheme:
        TextSelectionThemeData(selectionHandleColor: accentColor),
    shadowColor: Colors.black.withOpacity(0.08),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: accentColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ));

ThemeData materialLightTheme(accentColor) => ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: accentColor),
    primaryColor: accentColor,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle(
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
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: accentColor,
        ),
        fillColor: Colors.grey[100]),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.grey[200],
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    textSelectionTheme:
        TextSelectionThemeData(selectionHandleColor: accentColor),
    shadowColor: Colors.black.withOpacity(0.08),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: accentColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return null;
      }),
    ));
