// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yt_music_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YtMusicState _$YtMusicStateFromJson(Map<String, dynamic> json) => YtMusicState(
  language: YtMusicLanguage.fromJson(json['language'] as Map<String, dynamic>),
  location: YtMusicLocation.fromJson(json['location'] as Map<String, dynamic>),
  streamingQuality: $enumDecode(
    _$YTAudioQualityEnumMap,
    json['streamingQuality'],
  ),
  downloadingQuality: $enumDecode(
    _$YTAudioQualityEnumMap,
    json['downloadingQuality'],
  ),
  sponsorBlock: json['sponsorBlock'] as bool,
  sponsorBlockSponsor: json['sponsorBlockSponsor'] as bool,
  sponsorBlockSelfpromo: json['sponsorBlockSelfpromo'] as bool,
  sponsorBlockInteraction: json['sponsorBlockInteraction'] as bool,
  sponsorBlockIntro: json['sponsorBlockIntro'] as bool,
  sponsorBlockOutro: json['sponsorBlockOutro'] as bool,
  sponsorBlockPreview: json['sponsorBlockPreview'] as bool,
  sponsorBlockMusicOffTopic: json['sponsorBlockMusicOffTopic'] as bool,
  personalisedContent: json['personalisedContent'] as bool,
  visitorId: json['visitorId'] as String?,
);

Map<String, dynamic> _$YtMusicStateToJson(
  YtMusicState instance,
) => <String, dynamic>{
  'language': instance.language,
  'location': instance.location,
  'streamingQuality': _$YTAudioQualityEnumMap[instance.streamingQuality]!,
  'downloadingQuality': _$YTAudioQualityEnumMap[instance.downloadingQuality]!,
  'sponsorBlock': instance.sponsorBlock,
  'sponsorBlockSponsor': instance.sponsorBlockSponsor,
  'sponsorBlockSelfpromo': instance.sponsorBlockSelfpromo,
  'sponsorBlockInteraction': instance.sponsorBlockInteraction,
  'sponsorBlockIntro': instance.sponsorBlockIntro,
  'sponsorBlockOutro': instance.sponsorBlockOutro,
  'sponsorBlockPreview': instance.sponsorBlockPreview,
  'sponsorBlockMusicOffTopic': instance.sponsorBlockMusicOffTopic,
  'personalisedContent': instance.personalisedContent,
  'visitorId': instance.visitorId,
};

const _$YTAudioQualityEnumMap = {
  YTAudioQuality.high: 'high',
  YTAudioQuality.low: 'low',
};
