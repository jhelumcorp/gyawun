import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';

class PlayerSettings {
  PlayerSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Getters
  Future<bool?> get skipSilence =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.skipSilence);

  Stream<bool?> get skipSilenceStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.skipSilence).distinct();

  // Setter for completeness
  Future<void> setSkipSilence(bool value) =>
      _dao.setSetting<bool>(AppSettingsIdentifiers.skipSilence, value);
}
