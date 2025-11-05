import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Stream YouTube audio with seek support
class YouTubeAudioSource extends StreamAudioSource {
  final String videoId;
  final YoutubeExplode _yt;
  final YTAudioQuality audioQuality;
  late final Uri _audioUrl;
  late final int _totalBytes;
  late final String _contentType;
  bool _initialized = false;

  YouTubeAudioSource(
    this.videoId, {
    super.tag,
    this.audioQuality = YTAudioQuality.high,
  }) : _yt = YoutubeExplode();

  Future<void> _init() async {
    if (_initialized) return;

    final manifest = await _yt.videos.streamsClient.getManifest(
      videoId,
      // requireWatchPage: true,
      ytClients: [YoutubeApiClient.androidVr],
    );

    final streamInfo = manifest.audioOnly.withHighestBitrate();

    _audioUrl = Uri.parse(streamInfo.url.toString());
    _totalBytes = streamInfo.size.totalBytes;
    _contentType = streamInfo.codec.mimeType;
    _initialized = true;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    await _init();

    final client = HttpClient();
    final request = await client.getUrl(_audioUrl);

    // Add Range header if seeking
    if (start != null || end != null) {
      final rangeHeader = 'bytes=${start ?? 0}-${end != null ? end - 1 : ""}';
      request.headers.set(HttpHeaders.rangeHeader, rangeHeader);
    }

    final response = await request.close();

    final contentLength =
        int.tryParse(
          response.headers.value(HttpHeaders.contentLengthHeader) ?? '',
        ) ??
        _totalBytes;

    // Explicitly convert to Stream<Uint8List>
    final stream = response.map((List<int> chunk) => Uint8List.fromList(chunk));

    return StreamAudioResponse(
      sourceLength: _totalBytes,
      contentLength: contentLength,
      offset: start ?? 0,
      stream: stream,
      contentType: _contentType,
    );
  }
}

enum YTAudioQuality { high, low }
