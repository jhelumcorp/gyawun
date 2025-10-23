import 'dart:ui';

import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/settings/player_settings.dart';
import 'package:gyawun_music/core/settings/youtube_settings.dart';
import 'package:gyawun_music/database/settings/app_settings_dao.dart';
class AppSettings{
  AppSettingsDao dao;
  AppSettings(this.dao);

  Future<int> setBool(String key, bool value)=> dao.setBool(key, value);

  Future<int> setInt(String key, int value) => dao.setInt( key, value);

  Future<int> setString(String key, String value) =>dao.setString( key,  value);

  Future<int> setColor(String key, Color color) =>dao.setColor( key,  color);


  Stream<YtMusicSettings> youtube()=>youtubeSettingsStream(dao);
  Stream<AppAppearance> appearance()=>appearanceSettingsStream(dao);
  Stream<PlayerSettings> player()=>playerSettingsStream(dao);
}