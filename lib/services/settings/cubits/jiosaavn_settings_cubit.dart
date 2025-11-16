import 'package:gyawun_music/services/settings/states/jio_saavn_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../enums/js_audio_quality.dart';

class JioSaavnCubit extends HydratedCubit<JioSaavnState> {
  JioSaavnCubit()
    : super(
        const JioSaavnState(
          streamingQuality: JSAudioQuality.high,
          downloadingQuality: JSAudioQuality.high,
        ),
      );

  // Update streaming quality
  void setStreamingQuality(JSAudioQuality quality) {
    emit(state.copyWith(streamingQuality: quality));
  }

  // Update downloading quality
  void setDownloadingQuality(JSAudioQuality quality) {
    emit(state.copyWith(downloadingQuality: quality));
  }

  @override
  JioSaavnState? fromJson(Map<String, dynamic> json) => JioSaavnState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(JioSaavnState state) => state.toJson();
}
