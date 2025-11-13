import 'dart:convert';

import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class YtMusicSettings {
  YtMusicSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Individual Getters
  Future<YTAudioQuality> get audioStreamingQuality async {
    final value = await _dao.getSetting<String>(AppSettingsIdentifiers.ytAudioStreamingQuality);
    return value == 'high' ? YTAudioQuality.high : YTAudioQuality.low;
  }

  Future<String?> get audioDownloadingQuality =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytAudioDownloadingQuality);

  Future<String?> get language => _dao.getSetting<String>(AppSettingsIdentifiers.ytLanguage);

  Future<String?> get location => _dao.getSetting<String>(AppSettingsIdentifiers.ytLocation);

  Future<bool?> get personalisedContent =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.ytPersonalisedContent);

  Future<String?> get visitorId => _dao.getSetting<String>(AppSettingsIdentifiers.ytVisitorId);

  // Individual Streams
  Stream<String?> get streamingQualityStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytAudioStreamingQuality).distinct();
  Stream<String?> get downloadingQualityStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytAudioDownloadingQuality).distinct();

  Stream<String?> get languageStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytLanguage).distinct();

  Stream<String?> get locationStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytLocation).distinct();

  Stream<bool?> get personalisedContentStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.ytPersonalisedContent).distinct();

  Stream<String?> get visitorIdStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.ytVisitorId).distinct();

  // Combined Stream (returns complete YtMusicConfig object)
  Stream<YtMusicConfig> get stream {
    return Rx.combineLatestList([
      streamingQualityStream,
      downloadingQualityStream,
      languageStream,
      locationStream,
      personalisedContentStream,
      visitorIdStream,
    ]).map((values) {
      final streamingAudioQuality = values[0] ?? 'high';
      final downloadingAudioQuality = values[1] ?? 'high';
      final language = values[2] != null
          ? YtMusicLanguage.fromJson(jsonDecode(values[2] as String))
          : YtMusicLanguage(title: "English", value: 'en');
      final location = values[3] != null
          ? YtMusicLocation.fromJson(jsonDecode(values[3] as String))
          : YtMusicLocation(title: "India", value: 'IN');
      final personalisedContent = values[4] as bool? ?? true;
      final visitorId = values[5] as String?;

      YTAudioQuality streamingQuality;
      switch (streamingAudioQuality) {
        case 'low':
          streamingQuality = YTAudioQuality.low;
          break;
        default:
          streamingQuality = YTAudioQuality.high;
      }

      YTAudioQuality downloadingQuality;
      switch (downloadingAudioQuality) {
        case 'low':
          downloadingQuality = YTAudioQuality.low;
          break;
        default:
          downloadingQuality = YTAudioQuality.high;
      }

      return YtMusicConfig(
        streamingQuality: streamingQuality,
        downloadingQuality: downloadingQuality,
        language: language,
        location: location,
        personalisedContent: personalisedContent,
        visitorId: visitorId,
      );
    });
  }

  // Setters
  Future<void> setAudioStreamingQuality(YTAudioQuality quality) {
    final value = quality == YTAudioQuality.low ? 'low' : 'high';
    return _dao.setSetting(AppSettingsIdentifiers.ytAudioStreamingQuality, value);
  }

  Future<void> setAudioDownloadingQuality(YTAudioQuality quality) {
    final value = quality == YTAudioQuality.low ? 'low' : 'high';
    return _dao.setSetting(AppSettingsIdentifiers.ytAudioDownloadingQuality, value);
  }

  Future<void> setLanguage(YtMusicLanguage language) =>
      _dao.setSetting(AppSettingsIdentifiers.ytLanguage, jsonEncode(language.toJson()));

  Future<void> setLocation(YtMusicLocation location) =>
      _dao.setSetting(AppSettingsIdentifiers.ytLocation, jsonEncode(location.toJson()));

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
    required this.streamingQuality,
    required this.downloadingQuality,
    required this.language,
    required this.location,
    required this.personalisedContent,
    required this.visitorId,
  });
  final YTAudioQuality streamingQuality;
  final YTAudioQuality downloadingQuality;

  final YtMusicLanguage language;
  final YtMusicLocation location;
  final bool personalisedContent;
  final String? visitorId;

  YtMusicConfig copyWith({
    YTAudioQuality? streamingQuality,
    YTAudioQuality? downloadingQuality,
    YtMusicLanguage? language,
    YtMusicLocation? location,
    bool? personalisedContent,
    String? visitorId,
  }) {
    return YtMusicConfig(
      streamingQuality: streamingQuality ?? this.streamingQuality,
      downloadingQuality: downloadingQuality ?? this.downloadingQuality,
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

enum YTAudioQuality { high, low }
