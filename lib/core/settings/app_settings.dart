import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/settings/player_settings.dart';
import 'package:gyawun_music/core/settings/saavn_settings.dart';
import 'package:gyawun_music/core/settings/youtube_settings.dart';
import 'package:gyawun_music/database/settings/app_settings_dao.dart';

class AppSettings {
  AppSettings(this.dao);
  AppSettingsTableDao dao;

  AppearanceSettings get appearanceSettings => AppearanceSettings(dao);
  PlayerSettings get playerSettings => PlayerSettings(dao);
  YtMusicSettings get youtubeMusicSettings => YtMusicSettings(dao);
  JioSaavnSettings get jioSaavnSettings => JioSaavnSettings(dao);
}
