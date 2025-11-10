import 'package:gyawun_music/core/settings/player_settings.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

Future<void> initPlayerSettings(
  MediaPlayer player,
  PlayerSettings settings,
) async {
  await player.setShuffleModeEnabled((await settings.skipSilence) ?? false);
}
