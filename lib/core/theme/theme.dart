import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/theme/typography.dart';

class AppTheme {
  static ThemeData light({ColorScheme? colorScheme}) =>
      ThemeData.light(useMaterial3: true).copyWith(
        textTheme: appTextTheme(ThemeData.light().textTheme),
        colorScheme: colorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
      );
  static ThemeData dark({ColorScheme? colorScheme}) =>
      ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: appTextTheme(ThemeData.dark().textTheme),
        colorScheme: colorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
        ),
      );
}
