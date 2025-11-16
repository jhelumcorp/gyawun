import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../states/player_settings_state.dart';

class PlayerSettingsCubit extends HydratedCubit<PlayerSettingsState> {
  PlayerSettingsCubit()
    : super(
        const PlayerSettingsState(
          skipSilence: false,
          miniPlayerNextButton: true,
          miniPlayerPreviousButton: false,
        ),
      );

  void setSkipSilence(bool value) {
    emit(state.copyWith(skipSilence: value));
  }

  void setMiniPlayerNextButton(bool value) {
    emit(state.copyWith(miniPlayerNextButton: value));
  }

  void setMiniPlayerPreviousButton(bool value) {
    emit(state.copyWith(miniPlayerPreviousButton: value));
  }

  @override
  PlayerSettingsState? fromJson(Map<String, dynamic> json) => PlayerSettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PlayerSettingsState state) => state.toJson();
}
