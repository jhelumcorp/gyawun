import 'dart:ui';

import 'package:flutter/widgets.dart';

enum SearchProvider { saavn, youtube }

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
