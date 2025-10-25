import 'dart:io';

import 'package:flutter/material.dart';

extension ScreenSizeContext on BuildContext {
  bool get isWideScreen => MediaQuery.of(this).size.width >= 600;
  bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
