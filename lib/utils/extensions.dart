import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/settings_manager.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = watch<SettingsManager>().themeMode == ThemeMode.system
        ? MediaQuery.of(this).platformBrightness
        : watch<SettingsManager>().themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
    return brightness == Brightness.dark;
  }

  Color get subtitleColor =>
      isDarkMode ? Colors.white.withAlpha(150) : Colors.black.withAlpha(150);
  Color get bottomModalBackgroundColor => isDarkMode
      ? Color.alphaBlend(Colors.black.withAlpha(220), Colors.white)
      : Colors.white;
}
