import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontStyle = GoogleFonts.poppins();
ColorScheme darkScheme = const ColorScheme.dark();
ThemeData darkTheme(accentColor, {isPitchBlack = false}) =>
    ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: darkScheme.brightness,
          primary: accentColor,
          onPrimary: darkScheme.onPrimary,
          onPrimaryContainer: darkScheme.onPrimaryContainer,
          secondary: accentColor,
          tertiary: darkScheme.tertiary,
        ),
        scaffoldBackgroundColor:
            isPitchBlack ? Colors.black : const Color.fromARGB(255, 20, 20, 20),
        primaryColor: accentColor,
        useMaterial3: true,
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
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
                MaterialStateProperty.resolveWith((states) => Colors.white),
          ),
        ),
        cardColor: const Color.fromARGB(255, 30, 30, 30),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: accentColor,
          ),
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black12),
        textSelectionTheme:
            TextSelectionThemeData(selectionHandleColor: accentColor),
        shadowColor: Colors.black.withOpacity(0.2),
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

ThemeData materialDarkTheme(accentColor, {isPitchBlack = false}) =>
    ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: darkScheme.brightness,
          primary: accentColor,
          onPrimary: darkScheme.onPrimary,
          onPrimaryContainer: darkScheme.onPrimaryContainer,
          secondary: accentColor,
          tertiary: darkScheme.tertiary,
        ),
        scaffoldBackgroundColor:
            isPitchBlack ? Colors.black : const Color.fromARGB(255, 20, 20, 20),
        primaryColor: accentColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
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
                MaterialStateProperty.resolveWith((states) => Colors.white),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: isPitchBlack
              ? Colors.black
              : const Color.fromARGB(255, 20, 20, 20),
        ),
        cardColor: const Color.fromARGB(255, 30, 30, 30),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: accentColor,
          ),
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black12),
        textSelectionTheme:
            TextSelectionThemeData(selectionHandleColor: accentColor),
        shadowColor: Colors.black.withOpacity(0.2),
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
