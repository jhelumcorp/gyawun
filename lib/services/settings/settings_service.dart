import 'package:gyawun_music/services/settings/cubits/appearance_settings_cubit.dart';
import 'package:gyawun_music/services/settings/cubits/jiosaavn_settings_cubit.dart';
import 'package:gyawun_music/services/settings/cubits/player_settings_cubit.dart';
import 'package:gyawun_music/services/settings/cubits/yt_music_cubit.dart';

class SettingsService {
  SettingsService() {
    appearance = AppearanceSettingsCubit();
    jioSaavn = JioSaavnCubit();
    player = PlayerSettingsCubit();
    youtubeMusic = YtMusicCubit();
  }

  late final AppearanceSettingsCubit appearance;
  late final JioSaavnCubit jioSaavn;
  late final PlayerSettingsCubit player;
  late final YtMusicCubit youtubeMusic;
}
