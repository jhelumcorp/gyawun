import 'dart:async';
import 'package:gyawun/services/stream_client.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomAudioStream extends StreamAudioSource {
  late YoutubeExplode ytExplode;
  AudioOnlyStreamInfo? streamInfo;
  String videoId;
  String quality;

  CustomAudioStream(this.videoId, this.quality, {super.tag}) {
    ytExplode = YoutubeExplode();
  }

  Future _loadStreamInfo() async {
    StreamManifest manifest = await ytExplode.videos.streamsClient
        .getManifest(videoId, requireWatchPage: false);

    List<AudioOnlyStreamInfo> streamInfos = manifest.audioOnly
        .sortByBitrate()
        .reversed
        .where((stream) => stream.container == StreamContainer.mp4)
        .toList();

    int qualityIndex = quality == 'low' ? 0 : streamInfos.length - 1;
    streamInfo = streamInfos[qualityIndex];
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    if (streamInfo == null) {
      await _loadStreamInfo();
    }

    start ??= 0;
    int size = streamInfo!.bitrate.bitsPerSecond * 80;
    end ??= (streamInfo!.isThrottled
        ? (start + size)
        : streamInfo!.size.totalBytes);
    if (end > streamInfo!.size.totalBytes) {
      end = streamInfo!.size.totalBytes;
    }
    final response =
        AudioStreamClient().getAudioStream(streamInfo, start: start, end: end);

    return StreamAudioResponse(
      sourceLength: streamInfo!.size.totalBytes,
      contentLength: end - start,
      offset: start,
      stream: response,
      contentType: streamInfo!.codec.type,
    );
  }
}
