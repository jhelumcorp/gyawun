  import 'dart:convert';

import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:rxdart/rxdart.dart';

import '../../features/settings/app_settings_identifiers.dart';

Stream<YtMusicSettings> youtubeSettingsStream(AppSettingsDao dao){
    final audioQuality$ = dao
      .watchSetting<String>(AppSettingsIdentifiers.ytAudioQuality)
      .distinct();
    final language$ = dao
      .watchSetting<String>(AppSettingsIdentifiers.ytLanguage)
      .distinct();
  final location$ = dao
      .watchSetting<String>(AppSettingsIdentifiers.ytLocation)
      .distinct();
  final personalisedContent$ = dao
      .watchSetting<bool>(AppSettingsIdentifiers.ytPersonalisedContent)
      .distinct();
  final visitorId$ = dao
      .watchSetting<String?>(AppSettingsIdentifiers.ytVisitorId)
      .distinct();
  return Rx.combineLatestList([
    audioQuality$,
    language$,
    location$,
    personalisedContent$,
    visitorId$,
  ]).map((values) {
    final audioQuality = values[0] ?? 'high';
    final language = values[1] != null
        ? YtMusicLanguage.fromJson(jsonDecode(values[1] as String))
        : YtMusicLanguage(title: "English", value: 'en');
    final location = values[2] != null
        ? YtMusicLocation.fromJson(jsonDecode(values[2] as String))
        : YtMusicLocation(title: "India", value: 'IN');
    final personalisedContent = values[3] as bool? ?? true;
    final visitorId = values[4] as String?;
    AudioQuality quality;
    switch (audioQuality) {
      case 'low':
        quality = AudioQuality.low;
        break;
      default:
        quality = AudioQuality.high;
    }

    return YtMusicSettings(
      audioQuality: quality,
      language: language,
      location: location,
      personalisedContent: personalisedContent,
      visitorId: visitorId,
    );
  });
  }


class YtMusicSettings {
  final AudioQuality audioQuality;
  final YtMusicLanguage language;
  final YtMusicLocation location;
  final bool personalisedContent;
  final String? visitorId;

  const YtMusicSettings({
    required this.audioQuality,
    required this.language,
    required this.location,
    required this.personalisedContent,
    required this.visitorId,
  });

  YtMusicSettings copyWith({
    AudioQuality? audioQuality,
    bool? skipSilence,
    YtMusicLanguage? language,
    YtMusicLocation? location,
    bool? personalisedContent,
    String? visitorId,
  }) {
    return YtMusicSettings(
      audioQuality: audioQuality ?? this.audioQuality,
      language: language ?? this.language,
      location: location ?? this.location,
      personalisedContent: personalisedContent ?? this.personalisedContent,
      visitorId: visitorId ?? this.visitorId,
    );
  }
}


class YtMusicLanguage {
  final String title;
  final String value;

  YtMusicLanguage({required this.title, required this.value});
  factory YtMusicLanguage.fromJson(Map<String, dynamic> json) =>
      YtMusicLanguage(title: json['title'], value: json['value']);

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}

class YtMusicLocation {
  final String title;
  final String value;

  YtMusicLocation({required this.title, required this.value});
  factory YtMusicLocation.fromJson(Map<String, dynamic> json) =>
      YtMusicLocation(title: json['title'], value: json['value']);

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}

enum AudioQuality { low, high }