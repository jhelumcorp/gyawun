import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/di.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies();
  registerListeners();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}
