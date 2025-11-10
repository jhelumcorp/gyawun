import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class PlayerSettings {
  PlayerSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Individual Getters
  Future<bool?> get skipSilence => _dao.getSetting<bool>(AppSettingsIdentifiers.skipSilence);

  Future<bool?> get miniPlayerNextButton =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.miniPlayerNextButton);

  Future<bool?> get miniPlayerPreviousButton =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.miniPlayerPreviousButton);

  // Individual Streams
  Stream<bool?> get skipSilenceStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.skipSilence).distinct();

  Stream<bool?> get miniPlayerNextButtonStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.miniPlayerNextButton).distinct();
  Stream<bool?> get miniPlayerPreviousButtonStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.miniPlayerPreviousButton).distinct();

  // Combined Stream (for convenience - returns the complete AppPlayer object)
  Stream<AppPlayer> get stream {
    return Rx.combineLatestList([
      skipSilenceStream,
      miniPlayerNextButtonStream,
      miniPlayerPreviousButtonStream,
    ]).map((values) {
      final skipSilence = values[0] ?? false;
      final miniPlayerNextButton = values[1] ?? true;
      final miniPlayerPreviousButton = values[2] ?? false;

      return AppPlayer(
        skipSilence: skipSilence,
        miniPlayerNextButton: miniPlayerNextButton,
        miniPlayerPreviousButton: miniPlayerPreviousButton,
      );
    });
  }

  // Setters
  Future<void> setSkipSilence(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.skipSilence, value);

  Future<void> setMiniPlayerNextButton(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.miniPlayerNextButton, value);
  Future<void> setMiniPlayerPreviousButton(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.miniPlayerPreviousButton, value);
}

class AppPlayer {
  const AppPlayer({
    required this.skipSilence,
    required this.miniPlayerNextButton,
    required this.miniPlayerPreviousButton,
  });

  final bool skipSilence;
  final bool miniPlayerNextButton;
  final bool miniPlayerPreviousButton;

  AppPlayer copyWith({
    bool? skipSilence,
    bool? miniPlayerNextButton,
    bool? miniPlayerPreviousButton,
  }) {
    return AppPlayer(
      skipSilence: skipSilence ?? this.skipSilence,
      miniPlayerNextButton: miniPlayerNextButton ?? this.miniPlayerNextButton,
      miniPlayerPreviousButton: miniPlayerPreviousButton ?? this.miniPlayerPreviousButton,
    );
  }
}
