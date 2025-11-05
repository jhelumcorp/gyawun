import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies();
  final audiohandler = await initAudioService();
  sl.registerSingleton<MyAudioHandler>(audiohandler);
  registerListeners();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}
