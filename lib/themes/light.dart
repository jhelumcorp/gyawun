import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final defaultFontStyle = GoogleFonts.poppins();

ThemeData lightTheme(accentColor, {ColorScheme? colorScheme}) =>
    ThemeData.light().copyWith(
        colorScheme: colorScheme ??
            ColorScheme.fromSwatch(
                primarySwatch: colorScheme?.primary ?? accentColor),
        primaryColor:
            colorScheme?.primary ?? colorScheme?.primary ?? accentColor,
        scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          foregroundColor: Colors.black,
          surfaceTintColor: colorScheme == null ? Colors.transparent : null,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        dividerTheme: DividerThemeData(color: greyColor),
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
              color: colorScheme?.primary ?? accentColor,
            ),
            fillColor: Colors.grey[100]),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.grey[200],
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
        ),
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: colorScheme?.primary ?? accentColor),
        shadowColor: Colors.black.withOpacity(0.08),
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
