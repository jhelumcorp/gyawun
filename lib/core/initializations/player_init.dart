import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/states/player_settings_state.dart';

Future<void> initPlayerSettings(MediaPlayer player, PlayerSettingsState settings) async {
  await player.setShuffleModeEnabled(settings.skipSilence);
}
