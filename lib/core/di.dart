import 'package:get_it/get_it.dart';
import 'package:gyawun_music/database/database.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ytmusic/models/config.dart';
import 'package:ytmusic/yt_music_base.dart';

import 'settings/app_settings.dart';

final sl = GetIt.I;

Future<void> registerDependencies() async {
  sl.registerLazySingleton<AppSettingsDatabase>(() => AppSettingsDatabase());
  sl.registerLazySingleton<AppSettings>(() {
    final db = sl<AppSettingsDatabase>();
    return AppSettings(db.appSettingsTableDao);
  });
  sl.registerSingletonAsync<YTMusic>(() async {
    final appSettings = sl<AppSettings>();
    final ytMusicSettings = appSettings.youtubeMusicSettings;
    final ytmusicStream = await ytMusicSettings.stream.first;
    final dir = await getApplicationDocumentsDirectory();
    return YTMusic(
      config: YTConfig(
        visitorData: ytmusicStream.visitorId ?? "",
        language: ytmusicStream.language.value,
        location: ytmusicStream.location.value,
      ),
      cacheDatabasePath: join(dir.path, 'YTCACHE'),
      onConfigUpdate: (config) async {
        await ytMusicSettings.setVisitorId(config.visitorData);
      },
    );
  });
  final audiohandler = await initAudioService();
  sl.registerSingleton<MyAudioHandler>(audiohandler);

  sl.registerSingleton<MediaPlayer>(MediaPlayer(sl()));

  await sl.allReady();
}

void registerListeners() {
  sl<AppSettings>().youtubeMusicSettings.stream.listen((settings) {
    sl<YTMusic>().setConfig(
      YTConfig(
        visitorData: settings.visitorId ?? "",
        language: settings.language.value,
        location: settings.location.value,
      ),
    );
  });
}
