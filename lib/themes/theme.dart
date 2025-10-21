import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'typography.dart';

class AppTheme {
  static ThemeData light({Color? primary}) {
    final colorScheme = ColorScheme.fromSeed(
            seedColor: primary??Colors.red,
            brightness: Brightness.light,
          );

    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
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
      pageTransitionsTheme: PageTransitionsTheme(
        builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
          TargetPlatform.values,
          value: (_) => const FadeForwardsPageTransitionsBuilder(),
        ),
      ),
    );
  }

  static ThemeData dark({Color? primary, bool isPureBlack = false}) {
    final colorScheme = ColorScheme.fromSeed(
            seedColor: primary??Colors.deepPurpleAccent,
            brightness: Brightness.dark,
          );
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: isPureBlack
          ? Colors.black
          : colorScheme.surface,
      textTheme: appTextTheme(ThemeData.dark().textTheme),
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: isPureBlack ? Colors.black : null,
        surfaceTintColor: isPureBlack ? Colors.black : null,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isPureBlack ? Colors.black : null,
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
          TargetPlatform.values,
          value: (_) => const FadeForwardsPageTransitionsBuilder(),
        ),
      ),
    );
  }
}
