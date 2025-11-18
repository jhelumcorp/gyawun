import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/initializations/player_init.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationSupportDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );

  if (Platform.isLinux) {
    JustAudioMediaKit.ensureInitialized(linux: true);
    JustAudioMediaKit.title = 'Gyawun Music';
  }

  await registerDependencies(directory);

  await initPlayerSettings(sl<MediaPlayer>(), sl<SettingsService>().player.state);

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}
