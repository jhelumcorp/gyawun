// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gyawun_music/database/settings/app_appearence.dart';
// import 'package:gyawun_music/database/database.dart';
// import 'package:gyawun_music/database/settings/player_settings.dart';
// import 'package:gyawun_music/database/settings/yt_music_settings.dart';
// import '../database/settings/app_settings_dao.dart';

// final appDatabaseProvider = Provider<AppDatabase>((ref) {
//   return AppDatabase();
// });

// final appSettingsProvider = Provider<AppSettingsDao>((ref) {
//   final db = ref.watch(appDatabaseProvider);
//   return db.appSettingsDao;
// });

// final appearanceSettingsProvider = StreamProvider<AppAppearance>(
//   appAppearancehandler,
// );
// final playerSettingsProvider = StreamProvider<PlayerSettings>(
//   playerSettingshandler,
// );
// final ytMusicSettingsProvider = StreamProvider<YtMusicSettings>(
//   ytMusicSettingshandler,
// );
