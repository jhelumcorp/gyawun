import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaru/yaru.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux) {
    await YaruWindowTitleBar.ensureInitialized();
  }
  runApp(const ProviderScope(child: MyApp()));
}
