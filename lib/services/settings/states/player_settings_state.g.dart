// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerSettingsState _$PlayerSettingsStateFromJson(Map<String, dynamic> json) =>
    PlayerSettingsState(
      skipSilence: json['skipSilence'] as bool,
      miniPlayerNextButton: json['miniPlayerNextButton'] as bool,
      miniPlayerPreviousButton: json['miniPlayerPreviousButton'] as bool,
    );

Map<String, dynamic> _$PlayerSettingsStateToJson(
  PlayerSettingsState instance,
) => <String, dynamic>{
  'skipSilence': instance.skipSilence,
  'miniPlayerNextButton': instance.miniPlayerNextButton,
  'miniPlayerPreviousButton': instance.miniPlayerPreviousButton,
};
