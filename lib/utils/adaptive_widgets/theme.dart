import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class AdaptiveTheme {
  static ThemeData getMaterialTheme(BuildContext context) {
    return Theme.of(context);
  }

  static fluent_ui.FluentThemeData getFluentTheme(BuildContext context) {
    return fluent_ui.FluentTheme.of(context);
  }

  static AdaptiveThemeData of(BuildContext context) {
    AdaptiveThemeData adaptiveThemeData;
    if (Platform.isWindows) {
      final fluentTheme = fluent_ui.FluentTheme.of(context);
      adaptiveThemeData = AdaptiveThemeData(
          primaryColor: fluentTheme.accentColor,
          inactiveBackgroundColor: fluentTheme.inactiveBackgroundColor);
    } else {
      final materialTheme = Theme.of(context);
      adaptiveThemeData = AdaptiveThemeData(
        primaryColor: materialTheme.colorScheme.primary,
        inactiveBackgroundColor: materialTheme.scaffoldBackgroundColor,
      );
    }
    return adaptiveThemeData;
  }
}

class AdaptiveThemeData {
  Color primaryColor;
  Color inactiveBackgroundColor;
  AdaptiveThemeData(
      {required this.primaryColor, required this.inactiveBackgroundColor});
}
