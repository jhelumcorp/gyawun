import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/initializations/player_init.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    JustAudioMediaKit.ensureInitialized(linux: true);
    JustAudioMediaKit.title = 'Gyawun Music';
  }

  await registerDependencies();

  registerListeners();
  await initPlayerSettings(sl<MediaPlayer>(), sl<AppSettings>().playerSettings);

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}
