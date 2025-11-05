import 'package:get_it/get_it.dart';
import 'package:gyawun_music/database/database.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ytmusic/models/config.dart';
import 'package:ytmusic/yt_music_base.dart';

import 'settings/app_settings.dart';

final sl = GetIt.I;

Future<void> registerDependencies() async {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<AppSettings>(() {
    final db = sl<AppDatabase>();
    return AppSettings(db.appSettingsDao);
  });
  sl.registerSingletonAsync<YTMusic>(() async {
    final appSettings = sl<AppSettings>();
    final ytMusicSettings = await appSettings.youtube().first;
    final dir = await getApplicationDocumentsDirectory();
    return YTMusic(
      config: YTConfig(
        visitorData: ytMusicSettings.visitorId ?? "",
        language: ytMusicSettings.language.value,
        location: ytMusicSettings.location.value,
      ),
      cacheDatabasePath: dir.path,
      onConfigUpdate: (config) async {
        await appSettings.setString(
          AppSettingsIdentifiers.ytVisitorId,
          config.visitorData,
        );
      },
    );
  });

  await sl.allReady();
}

void registerListeners() {
  sl<AppSettings>().youtube().listen((settings) {
    sl<YTMusic>().setConfig(
      YTConfig(
        visitorData: settings.visitorId ?? "",
        language: settings.language.value,
        location: settings.location.value,
      ),
    );
  });
}
