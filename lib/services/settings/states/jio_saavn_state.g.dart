// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jio_saavn_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JioSaavnState _$JioSaavnStateFromJson(Map<String, dynamic> json) =>
    JioSaavnState(
      streamingQuality: $enumDecode(
        _$JSAudioQualityEnumMap,
        json['streamingQuality'],
      ),
      downloadingQuality: $enumDecode(
        _$JSAudioQualityEnumMap,
        json['downloadingQuality'],
      ),
    );

Map<String, dynamic> _$JioSaavnStateToJson(
  JioSaavnState instance,
) => <String, dynamic>{
  'streamingQuality': _$JSAudioQualityEnumMap[instance.streamingQuality]!,
  'downloadingQuality': _$JSAudioQualityEnumMap[instance.downloadingQuality]!,
};

const _$JSAudioQualityEnumMap = {
  JSAudioQuality.high: 'high',
  JSAudioQuality.medium: 'medium',
  JSAudioQuality.low: 'low',
};
