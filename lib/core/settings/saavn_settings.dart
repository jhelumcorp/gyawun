import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class JioSaavnSettings {
  JioSaavnSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Individual Getters
  Future<JSAudioQuality> get audioStreamingQuality async {
    final value = await _dao.getSetting<int>(AppSettingsIdentifiers.ytAudioStreamingQuality);
    return JSAudioQuality.fromBitrate(value ?? 320);
  }

  Future<String?> get audioDownloadingQuality =>
      _dao.getSetting<String>(AppSettingsIdentifiers.ytAudioDownloadingQuality);
  Stream<int?> get streamingQualityStream =>
      _dao.watchSetting<int>(AppSettingsIdentifiers.ytAudioStreamingQuality).distinct();
  Stream<int?> get downloadingQualityStream =>
      _dao.watchSetting<int>(AppSettingsIdentifiers.ytAudioDownloadingQuality).distinct();

  Stream<JioSaavnConfig> get stream {
    return Rx.combineLatestList([streamingQualityStream, downloadingQualityStream]).map((values) {
      final streamingAudioQuality = (values[0] ?? 320);
      final downloadingAudioQuality = (values[1] ?? 320);

      JSAudioQuality streamingQuality = JSAudioQuality.fromBitrate(streamingAudioQuality);

      JSAudioQuality downloadingQuality = JSAudioQuality.fromBitrate(downloadingAudioQuality);

      return JioSaavnConfig(
        streamingQuality: streamingQuality,
        downloadingQuality: downloadingQuality,
      );
    });
  }

  // Setters
  Future<void> setAudioStreamingQuality(JSAudioQuality quality) {
    final value = quality.bitrate;
    return _dao.setSetting(AppSettingsIdentifiers.ytAudioStreamingQuality, value);
  }

  Future<void> setAudioDownloadingQuality(JSAudioQuality quality) {
    final value = quality.bitrate;
    return _dao.setSetting(AppSettingsIdentifiers.ytAudioDownloadingQuality, value);
  }
}

class JioSaavnConfig {
  const JioSaavnConfig({required this.streamingQuality, required this.downloadingQuality});
  final JSAudioQuality streamingQuality;
  final JSAudioQuality downloadingQuality;

  JioSaavnConfig copyWith({JSAudioQuality? streamingQuality, JSAudioQuality? downloadingQuality}) {
    return JioSaavnConfig(
      streamingQuality: streamingQuality ?? this.streamingQuality,
      downloadingQuality: downloadingQuality ?? this.downloadingQuality,
    );
  }
}

enum JSAudioQuality {
  high(320),
  medium(160),
  low(96);

  const JSAudioQuality(this.bitrate);

  /// Bitrate in kbps
  final int bitrate;

  /// Create from bitrate value (METHOD 1 - Recommended)
  static JSAudioQuality fromBitrate(int bitrate) {
    return JSAudioQuality.values.firstWhere(
      (q) => q.bitrate == bitrate,
      orElse: () => JSAudioQuality.medium,
    );
  }

  /// Create from enum index (METHOD 2)
  static JSAudioQuality fromIndex(int index) {
    if (index >= 0 && index < JSAudioQuality.values.length) {
      return JSAudioQuality.values[index];
    }
    return JSAudioQuality.medium; // default
  }
}
