import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final defaultFontStyle = GoogleFonts.poppins();
ColorScheme darkScheme = const ColorScheme.dark();
ThemeData darkTheme(Color accentColor,
        {isPitchBlack = true, ColorScheme? colorScheme}) =>
    ThemeData.dark().copyWith(
        colorScheme: colorScheme ??
            ColorScheme.fromSeed(
              seedColor: accentColor,
              brightness: darkScheme.brightness,
              primary: accentColor,
              primaryContainer: accentColor,
              onPrimaryContainer: Colors.black,
              surface: accentColor.withAlpha(10),
            ),
        dividerTheme: DividerThemeData(color: greyColor),
        scaffoldBackgroundColor: colorScheme != null
            ? null
            : isPitchBlack
                ? Colors.black
                : const Color.fromARGB(255, 20, 20, 20),
        primaryColor: colorScheme?.primary ?? accentColor,
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          surfaceTintColor: colorScheme == null ? Colors.transparent : null,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: darkGreyColor,
          selectedItemColor: Colors.white,
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
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor:
                WidgetStateProperty.resolveWith((states) => Colors.white),
          ),
        ),
        cardColor: const Color.fromARGB(255, 30, 30, 30),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: colorScheme?.primary ?? accentColor,
          ),
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black12),
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: colorScheme?.primary ?? accentColor),
        shadowColor: Colors.black.withOpacity(0.2),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: colorScheme?.primary ?? accentColor,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return colorScheme?.primary ?? accentColor;
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return colorScheme?.primary ?? accentColor;
            }
            return null;
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return colorScheme?.primary ?? accentColor;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.selected)) {
              return colorScheme?.primary ?? accentColor;
            }
            return null;
          }),
        ));
