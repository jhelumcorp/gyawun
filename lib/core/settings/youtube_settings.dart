import 'dart:convert';

import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class YtMusicSettings {
  YtMusicSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Individual Getters
  Future<String?> get audioQuality =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytAudioQuality);

  Future<String?> get language =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytLanguage);

  Future<String?> get location =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytLocation);

  Future<bool?> get personalisedContent =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.ytPersonalisedContent);

  Future<String?> get visitorId =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytVisitorId);

  // Individual Streams
  Stream<String?> get audioQualityStream => _dao
      .watchSetting<String>(AppSettingsIdentifiers.ytAudioQuality)
      .distinct();

  Stream<String?> get languageStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytLanguage).distinct();

  Stream<String?> get locationStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytLocation).distinct();

  Stream<bool?> get personalisedContentStream => _dao
      .watchSetting<bool>(AppSettingsIdentifiers.ytPersonalisedContent)
      .distinct();

  Stream<String?> get visitorIdStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytVisitorId).distinct();

  // Combined Stream (returns complete YtMusicConfig object)
  Stream<YtMusicConfig> get stream {
    return Rx.combineLatestList([
      audioQualityStream,
      languageStream,
      locationStream,
      personalisedContentStream,
      visitorIdStream,
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

      return YtMusicConfig(
        audioQuality: quality,
        language: language,
        location: location,
        personalisedContent: personalisedContent,
        visitorId: visitorId,
      );
    });
  }

  // Setters
  Future<void> setAudioQuality(AudioQuality quality) {
    final value = quality == AudioQuality.low ? 'low' : 'high';
    return _dao.setSetting(AppSettingsIdentifiers.ytAudioQuality, value);
  }

  Future<void> setLanguage(YtMusicLanguage language) => _dao.setSetting(
    AppSettingsIdentifiers.ytLanguage,
    jsonEncode(language.toJson()),
  );

  Future<void> setLocation(YtMusicLocation location) => _dao.setSetting(
    AppSettingsIdentifiers.ytLocation,
    jsonEncode(location.toJson()),
  );

  Future<void> setPersonalisedContent(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.ytPersonalisedContent, value);

  Future<void> setVisitorId(String? value) {
    if (value == null) {
      // Handle deletion if needed
      return Future.value();
    }
    return _dao.setSetting(AppSettingsIdentifiers.ytVisitorId, value);
  }
}

class YtMusicConfig {
  const YtMusicConfig({
    required this.audioQuality,
    required this.language,
    required this.location,
    required this.personalisedContent,
    required this.visitorId,
  });
  final AudioQuality audioQuality;
  final YtMusicLanguage language;
  final YtMusicLocation location;
  final bool personalisedContent;
  final String? visitorId;

  YtMusicConfig copyWith({
    AudioQuality? audioQuality,
    YtMusicLanguage? language,
    YtMusicLocation? location,
    bool? personalisedContent,
    String? visitorId,
  }) {
    return YtMusicConfig(
      audioQuality: audioQuality ?? this.audioQuality,
      language: language ?? this.language,
      location: location ?? this.location,
      personalisedContent: personalisedContent ?? this.personalisedContent,
      visitorId: visitorId ?? this.visitorId,
    );
  }
}

class YtMusicLanguage {
  YtMusicLanguage({required this.title, required this.value});

  factory YtMusicLanguage.fromJson(Map<String, dynamic> json) =>
      YtMusicLanguage(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}

class YtMusicLocation {
  YtMusicLocation({required this.title, required this.value});

  factory YtMusicLocation.fromJson(Map<String, dynamic> json) =>
      YtMusicLocation(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}

enum AudioQuality { low, high }
