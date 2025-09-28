import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/providers/database_provider.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class PlayerSettings {
  final bool skipSilence;

  const PlayerSettings({required this.skipSilence});

  PlayerSettings copyWith({bool? skipSilence}) {
    return PlayerSettings(skipSilence: skipSilence ?? this.skipSilence);
  }
}

Stream<PlayerSettings> playerSettingshandler(Ref ref) {
  final dao = ref.watch(appSettingsProvider);

  final skipSilence$ = dao
      .watchSetting<bool>(AppSettingsIdentifiers.skipSilence)
      .distinct();

  return Rx.combineLatestList([skipSilence$]).map((values) {
    final skipSilence = values[0] ?? false;

    return PlayerSettings(skipSilence: skipSilence);
  });
}
