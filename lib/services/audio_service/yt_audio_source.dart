import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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

  late final Uri _audioUrl;
  late final int _totalBytes;
  late final String _contentType;

  bool _initialized = false;

  static final HttpClient _sharedClient = HttpClient();

  Future<void> _init() async {
    if (_initialized) return;

    final manifest = await yt.videos.streamsClient.getManifest(
      videoId,
      ytClients: [YoutubeApiClient.androidVr], // works + best availability
    );

    // Choose best audio-only stream
    final streamInfo = manifest.audioOnly.withHighestBitrate();

    _audioUrl = Uri.parse(streamInfo.url.toString());
    _totalBytes = streamInfo.size.totalBytes;
    _contentType = streamInfo.codec.mimeType;

    _initialized = true;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    await _init();

    final request = await _sharedClient.getUrl(_audioUrl);

    // Add Range header for seek operations
    if (start != null || end != null) {
      request.headers.set(
        HttpHeaders.rangeHeader,
        'bytes=${start ?? 0}-${end ?? ""}',
      );
    }

    final response = await request.close();

    final contentLength =
        int.tryParse(
          response.headers.value(HttpHeaders.contentLengthHeader) ?? '',
        ) ??
        _totalBytes;

    // Convert stream to Uint8List
    final stream = response.map((data) => Uint8List.fromList(data));

    return StreamAudioResponse(
      sourceLength: _totalBytes,
      contentLength: contentLength,
      offset: start ?? 0,
      stream: stream,
      contentType: _contentType,
    );
  }

  // @override
  // Future<void> dispose() async {
  //   await _yt.close(); // Prevents memory leaks
  //   return super.close();
  // }
}

enum YTAudioQuality { high, low }
