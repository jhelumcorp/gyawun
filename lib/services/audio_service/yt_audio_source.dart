import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../settings/enums/yt_audio_quality.dart';

/// Stream YouTube audio with full seek support.
class YouTubeAudioSource extends StreamAudioSource {
  YouTubeAudioSource(
    this.videoId, {
    required this.yt, // <— pass from above
    super.tag,
    this.audioQuality = YTAudioQuality.high,
  });
  final String videoId;
  final YoutubeExplode yt;
  final YTAudioQuality audioQuality;

  late final int _totalBytes;
  late final String _contentType;
  late final AudioOnlyStreamInfo _streamInfo;

  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    final manifest = await yt.videos.streamsClient.getManifest(
      videoId,
      ytClients: [YoutubeApiClient.androidVr], // works + best availability
    );

    // Choose best audio-only stream
    _streamInfo = manifest.audioOnly.withHighestBitrate();

    _totalBytes = _streamInfo.size.totalBytes;
    _contentType = _streamInfo.codec.mimeType;

    _initialized = true;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    await _init();

    start ??= 0;
    end ??= (_streamInfo.isThrottled ? (end ?? (start + 10379935)) : _streamInfo.size.totalBytes);
    if (end > _streamInfo.size.totalBytes) {
      end = _streamInfo.size.totalBytes;
    }

    final stream = yt.videos.streamsClient.get(_streamInfo, start, end);

    return StreamAudioResponse(
      sourceLength: _totalBytes,
      contentLength: end - start,
      offset: start,
      stream: stream,
      contentType: _contentType,
    );
  }
}
