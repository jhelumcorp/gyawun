import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class PlayerSettings {
  final bool skipSilence;

  const PlayerSettings({required this.skipSilence});

  PlayerSettings copyWith({bool? skipSilence}) {
    return PlayerSettings(skipSilence: skipSilence ?? this.skipSilence);
  }
}

Stream<PlayerSettings> playerSettingsStream(AppSettingsDao dao) {

  final skipSilence$ = dao
      .watchSetting<bool>(AppSettingsIdentifiers.skipSilence)
      .distinct();

  return Rx.combineLatestList([skipSilence$]).map((values) {
    final skipSilence = values[0] ?? false;

    return PlayerSettings(skipSilence: skipSilence);
  });
}
