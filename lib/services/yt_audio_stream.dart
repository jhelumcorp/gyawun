import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeAudioSource extends StreamAudioSource {
  final String videoId;
  final String quality; // 'high' or 'low'
  final YoutubeExplode ytExplode;

  YouTubeAudioSource({
    required this.videoId,
    required this.quality,
    super.tag,
  }) : ytExplode = YoutubeExplode();

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    try {
      final manifest = await ytExplode.videos.streams.getManifest(videoId,
          requireWatchPage: true, ytClients: [YoutubeApiClient.androidVr]);
      final supportedStreams = manifest.audioOnly.sortByBitrate();

      final audioStream = quality == 'high'
          ? supportedStreams.firstOrNull
          : supportedStreams.lastOrNull;

      if (audioStream == null) {
        throw Exception('No audio stream available for this video.');
      }

      start ??= 0;
      end ??= (audioStream.isThrottled
          ? (end ?? (start + 10379935))
          : audioStream.size.totalBytes);
      if (end > audioStream.size.totalBytes) {
        end = audioStream.size.totalBytes;
      }

      final stream = ytExplode.videos.streams.get(audioStream, start, end);
      return StreamAudioResponse(
        sourceLength: audioStream.size.totalBytes,
        contentLength: end - start,
        offset: start,
        stream: stream,
        contentType: audioStream.codec.mimeType,
      );
    } catch (e) {
      throw Exception('Failed to load audio: $e');
    }
  }
}
