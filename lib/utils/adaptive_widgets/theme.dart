import 'package:flutter/material.dart';

class AdaptiveTheme {
  static ThemeData getMaterialTheme(BuildContext context) {
    return Theme.of(context);
  }

  static AdaptiveThemeData of(BuildContext context) {
    AdaptiveThemeData adaptiveThemeData;
    final materialTheme = Theme.of(context);
    adaptiveThemeData = AdaptiveThemeData(
      primaryColor: materialTheme.colorScheme.primary,
      inactiveBackgroundColor: materialTheme.scaffoldBackgroundColor,
    );
    return adaptiveThemeData;
  }
}

class AdaptiveThemeData {
  Color primaryColor;
  Color inactiveBackgroundColor;
  AdaptiveThemeData(
      {required this.primaryColor, required this.inactiveBackgroundColor});
}
