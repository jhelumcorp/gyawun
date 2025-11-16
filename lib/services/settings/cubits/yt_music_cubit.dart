import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../enums/yt_audio_quality.dart';
import '../models/yt_music_language.dart';
import '../models/yt_music_location.dart';
import '../states/yt_music_state.dart';

class YtMusicCubit extends HydratedCubit<YtMusicState> {
  YtMusicCubit()
    : super(
        YtMusicState(
          language: YtMusicLanguage(title: 'English', value: 'en'),
          location: YtMusicLocation(title: 'India', value: 'IN'),
          streamingQuality: YTAudioQuality.high,
          downloadingQuality: YTAudioQuality.high,
          sponsorBlock: false,
          sponsorBlockSponsor: true,
          sponsorBlockSelfpromo: true,
          sponsorBlockInteraction: false,
          sponsorBlockIntro: false,
          sponsorBlockOutro: false,
          sponsorBlockPreview: false,
          sponsorBlockMusicOffTopic: false,
          personalisedContent: false,
          visitorId: null,
        ),
      );

  // All setter methods
  void setLanguage(YtMusicLanguage v) => emit(state.copyWith(language: v));
  void setLocation(YtMusicLocation v) => emit(state.copyWith(location: v));

  void setAudioStreamingQuality(YTAudioQuality q) => emit(state.copyWith(streamingQuality: q));

  void setAudioDownloadingQuality(YTAudioQuality q) => emit(state.copyWith(downloadingQuality: q));

  void setSponsorBlock(bool v) => emit(state.copyWith(sponsorBlock: v));
  void setSponsorBlockSponsor(bool v) => emit(state.copyWith(sponsorBlockSponsor: v));
  void setSponsorBlockSelfPromo(bool v) => emit(state.copyWith(sponsorBlockSelfpromo: v));
  void setSponsorBlockInteraction(bool v) => emit(state.copyWith(sponsorBlockInteraction: v));
  void setSponsorBlockIntro(bool v) => emit(state.copyWith(sponsorBlockIntro: v));
  void setSponsorBlockOutro(bool v) => emit(state.copyWith(sponsorBlockOutro: v));
  void setSponsorBlockPreview(bool v) => emit(state.copyWith(sponsorBlockPreview: v));
  void setSponsorBlockMusicOffTopic(bool v) => emit(state.copyWith(sponsorBlockMusicOffTopic: v));

  void setPersonalisedContent(bool v) => emit(state.copyWith(personalisedContent: v));

  void setVisitorId(String? v) => emit(state.copyWith(visitorId: v));

  @override
  YtMusicState? fromJson(Map<String, dynamic> json) => YtMusicState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(YtMusicState state) => state.toJson();
}
