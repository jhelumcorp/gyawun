import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/settings/player_settings.dart';
import 'package:gyawun_music/core/settings/youtube_settings.dart';
import 'package:gyawun_music/database/settings/app_settings_dao.dart';

class AppSettings {
  AppSettings(this.dao);
  AppSettingsTableDao dao;

  YtMusicSettings get youtubeMusicSettings => YtMusicSettings(dao);
  AppearanceSettings get appearanceSettings => AppearanceSettings(dao);
  PlayerSettings get playerSettings => PlayerSettings(dao);
}
