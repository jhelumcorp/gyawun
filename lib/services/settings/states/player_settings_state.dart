import 'package:json_annotation/json_annotation.dart';

part 'player_settings_state.g.dart';

@JsonSerializable()
class PlayerSettingsState {
  factory PlayerSettingsState.fromJson(Map<String, dynamic> json) =>
      _$PlayerSettingsStateFromJson(json);

  const PlayerSettingsState({
    required this.skipSilence,
    required this.miniPlayerNextButton,
    required this.miniPlayerPreviousButton,
  });
  final bool skipSilence;
  final bool miniPlayerNextButton;
  final bool miniPlayerPreviousButton;

  PlayerSettingsState copyWith({
    bool? skipSilence,
    bool? miniPlayerNextButton,
    bool? miniPlayerPreviousButton,
  }) {
    return PlayerSettingsState(
      skipSilence: skipSilence ?? this.skipSilence,
      miniPlayerNextButton: miniPlayerNextButton ?? this.miniPlayerNextButton,
      miniPlayerPreviousButton: miniPlayerPreviousButton ?? this.miniPlayerPreviousButton,
    );
  }

  Map<String, dynamic> toJson() => _$PlayerSettingsStateToJson(this);
}
