import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'stream_client.dart';

YoutubeExplode ytExplode = YoutubeExplode();

class CustomAudioStream extends StreamAudioSource {
  String videoId;
  String quality;

  CustomAudioStream(this.videoId, this.quality, {super.tag});

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    StreamManifest manifest =
        await ytExplode.videos.streamsClient.getManifest(videoId);

    List<AudioOnlyStreamInfo> streamInfos = manifest.audioOnly
        .sortByBitrate()
        .reversed
        .where((stream) => stream.container == StreamContainer.mp4)
        .toList();
    int qualityIndex = streamInfos.length - 1;
    if (quality == 'low') {
      qualityIndex = 0;
    } else {
      qualityIndex = streamInfos.length - 1;
    }
    AudioOnlyStreamInfo streamInfo = streamInfos[qualityIndex];
    start ??= 0;

    end ??= (streamInfo.isThrottled
        ? (start + 10379935)
        : streamInfo.size.totalBytes);
    if (end > streamInfo.size.totalBytes) {
      end = streamInfo.size.totalBytes;
    }
    return StreamAudioResponse(
      sourceLength: streamInfo.size.totalBytes,
      contentLength: end - start,
      offset: start,
      stream: AudioStreamClient()
          .getAudioStream(streamInfo, start: start, end: end),
      contentType: streamInfo.codec.type,
    );
  }
}
