import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/audio_service/sponsor_block.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:jio_saavn/jio_saavn.dart';
import 'package:library_manager/library_manager.dart';
import 'package:path/path.dart' as p;
import 'package:ytmusic/models/config.dart';
import 'package:ytmusic/yt_music_base.dart';

final sl = GetIt.I;

Future<void> registerDependencies(Directory directory) async {
  sl.registerLazySingleton<SettingsService>(() => SettingsService());

  sl.registerLazySingleton<JioSaavn>(() => JioSaavn(null));
  sl.registerLazySingleton<YTMusic>(() {
    final ytMusicSettings = sl<SettingsService>().youtubeMusic;
    final ytmusic = ytMusicSettings.state;
    return YTMusic(
      config: YTConfig(
        visitorData: ytmusic.visitorId ?? "",
        language: ytmusic.language.value,
        location: ytmusic.location.value,
      ),
      onIdUpdate: (config) async {
        ytMusicSettings.setVisitorId(config);
      },
    );
  });
  final audiohandler = await initAudioService();
  sl.registerSingleton<MyAudioHandler>(audiohandler, dispose: (service) => service.dispose());

  sl.registerSingleton<MediaPlayer>(MediaPlayer(sl()), dispose: (service) => service.dispose());
  sl.registerLazySingleton(
    () => SponsorBlockService(sl(), sl<SettingsService>().youtubeMusic),
    dispose: (service) => service.dispose(),
  );
  final dbPath = p.join(directory.path, "library_manager", "playlists.db");
  sl.registerLazySingleton<LibraryManager>(() => LibraryManager(databasePath: dbPath));

  await sl.allReady();
}
