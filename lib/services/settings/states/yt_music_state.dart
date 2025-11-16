import 'package:json_annotation/json_annotation.dart';

import '../enums/yt_audio_quality.dart';
import '../models/yt_music_language.dart';
import '../models/yt_music_location.dart';

part 'yt_music_state.g.dart';

@JsonSerializable()
class YtMusicState {
  factory YtMusicState.fromJson(Map<String, dynamic> json) => _$YtMusicStateFromJson(json);
  const YtMusicState({
    required this.language,
    required this.location,
    required this.streamingQuality,
    required this.downloadingQuality,
    required this.sponsorBlock,
    required this.sponsorBlockSponsor,
    required this.sponsorBlockSelfpromo,
    required this.sponsorBlockInteraction,
    required this.sponsorBlockIntro,
    required this.sponsorBlockOutro,
    required this.sponsorBlockPreview,
    required this.sponsorBlockMusicOffTopic,
    required this.personalisedContent,
    required this.visitorId,
  });
  final YtMusicLanguage language;
  final YtMusicLocation location;
  final YTAudioQuality streamingQuality;
  final YTAudioQuality downloadingQuality;

  final bool sponsorBlock;
  final bool sponsorBlockSponsor;
  final bool sponsorBlockSelfpromo;
  final bool sponsorBlockInteraction;
  final bool sponsorBlockIntro;
  final bool sponsorBlockOutro;
  final bool sponsorBlockPreview;
  final bool sponsorBlockMusicOffTopic;

  final bool personalisedContent;
  final String? visitorId;

  YtMusicState copyWith({
    YtMusicLanguage? language,
    YtMusicLocation? location,
    YTAudioQuality? streamingQuality,
    YTAudioQuality? downloadingQuality,
    bool? sponsorBlock,
    bool? sponsorBlockSponsor,
    bool? sponsorBlockSelfpromo,
    bool? sponsorBlockInteraction,
    bool? sponsorBlockIntro,
    bool? sponsorBlockOutro,
    bool? sponsorBlockPreview,
    bool? sponsorBlockMusicOffTopic,
    bool? personalisedContent,
    String? visitorId,
  }) {
    return YtMusicState(
      language: language ?? this.language,
      location: location ?? this.location,
      streamingQuality: streamingQuality ?? this.streamingQuality,
      downloadingQuality: downloadingQuality ?? this.downloadingQuality,
      sponsorBlock: sponsorBlock ?? this.sponsorBlock,
      sponsorBlockSponsor: sponsorBlockSponsor ?? this.sponsorBlockSponsor,
      sponsorBlockSelfpromo: sponsorBlockSelfpromo ?? this.sponsorBlockSelfpromo,
      sponsorBlockInteraction: sponsorBlockInteraction ?? this.sponsorBlockInteraction,
      sponsorBlockIntro: sponsorBlockIntro ?? this.sponsorBlockIntro,
      sponsorBlockOutro: sponsorBlockOutro ?? this.sponsorBlockOutro,
      sponsorBlockPreview: sponsorBlockPreview ?? this.sponsorBlockPreview,
      sponsorBlockMusicOffTopic: sponsorBlockMusicOffTopic ?? this.sponsorBlockMusicOffTopic,
      personalisedContent: personalisedContent ?? this.personalisedContent,
      visitorId: visitorId,
    );
  }

  Map<String, dynamic> toJson() => _$YtMusicStateToJson(this);
}
