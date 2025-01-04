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
    streamInfo = streamInfos[qualityIndex];
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    if (streamInfo == null) {
      await _loadStreamInfo();
    }

    start ??= 0;
    end ??= (streamInfo!.isThrottled
        ? (start + 10379935)
        : streamInfo!.size.totalBytes);
    if (end > streamInfo!.size.totalBytes) {
      end = streamInfo!.size.totalBytes;
    }

    bool isFirstChunk = (start == 0);
    if (isFirstChunk) {
      final e = start + (1024 * 100);
      // Send a small chunk (e.g., 100 KB) for the first request
      end = e < streamInfo!.size.totalBytes ? e : end;
    }
    // var byteRange = 'bytes=$start-$end';
    // var url = streamInfo!.url;
    // var headers = {
    //   HttpHeaders.contentTypeHeader: streamInfo!.codec.type,
    //   HttpHeaders.rangeHeader: byteRange,
    // };
    // var request = http.Request('GET', url)..headers.addAll(headers);

    // final response = await request.send();
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
