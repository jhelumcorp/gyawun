import 'package:get_it/get_it.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/audio_service/sponsor_block.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:jio_saavn/jio_saavn.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ytmusic/models/config.dart';
import 'package:ytmusic/yt_music_base.dart';

final sl = GetIt.I;

Future<void> registerDependencies() async {
  sl.registerLazySingleton<SettingsService>(() => SettingsService());

  sl.registerLazySingleton<JioSaavn>(() => JioSaavn(null));
  sl.registerSingletonAsync<YTMusic>(() async {
    final ytMusicSettings = sl<SettingsService>().youtubeMusic;

    final ytmusic = ytMusicSettings.state;
    final dir = await getApplicationDocumentsDirectory();
    return YTMusic(
      config: YTConfig(
        visitorData: ytmusic.visitorId ?? "",
        language: ytmusic.language.value,
        location: ytmusic.location.value,
      ),
      cacheDatabasePath: join(dir.path, 'YTCACHE'),
      onConfigUpdate: (config) async {
        ytMusicSettings.setVisitorId(config.visitorData);
      },
    );
  });
  final audiohandler = await initAudioService();
  sl.registerSingleton<MyAudioHandler>(audiohandler);

  sl.registerSingleton<MediaPlayer>(MediaPlayer(sl()));
  sl.registerLazySingleton(() => SponsorBlockService());

  await sl.allReady();
}

void registerListeners() {
  // sl<SettingsService>().youtubeMusic.stream.listen((settings) {
  //   sl<YTMusic>().setConfig(
  //     YTConfig(
  //       visitorData: settings.visitorId ?? "",
  //       language: settings.language.value,
  //       location: settings.location.value,
  //     ),
  //   );
  // });
}
