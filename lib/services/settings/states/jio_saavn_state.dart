import 'package:json_annotation/json_annotation.dart';

import '../enums/js_audio_quality.dart';

part 'jio_saavn_state.g.dart';

@JsonSerializable()
class JioSaavnState {
  factory JioSaavnState.fromJson(Map<String, dynamic> json) => _$JioSaavnStateFromJson(json);
  const JioSaavnState({required this.streamingQuality, required this.downloadingQuality});
  final JSAudioQuality streamingQuality;
  final JSAudioQuality downloadingQuality;

  JioSaavnState copyWith({JSAudioQuality? streamingQuality, JSAudioQuality? downloadingQuality}) {
    return JioSaavnState(
      streamingQuality: streamingQuality ?? this.streamingQuality,
      downloadingQuality: downloadingQuality ?? this.downloadingQuality,
    );
  }

  Map<String, dynamic> toJson() => _$JioSaavnStateToJson(this);
}
