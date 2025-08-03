import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/theme/typography.dart';
import 'package:gyawun_music/core/utils/custom_slide_route.dart';

class AppTheme {
  static ThemeData light({ColorScheme? colorScheme}) =>
      ThemeData.light(useMaterial3: true).copyWith(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SlideFromRightTransitionsBuilder(),
          },
        ),
        scaffoldBackgroundColor: colorScheme?.surface,
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
        scaffoldBackgroundColor: colorScheme?.surface,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SlideFromRightTransitionsBuilder(),
          },
        ),
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
