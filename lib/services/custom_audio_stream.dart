// import 'dart:async';
// import 'package:gyawun/services/stream_client.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// mixin HlsStreamInfo on StreamInfo {
//   /// The tag of the audio stream related to this stream.
//   int? get audioItag => null;
// }

// class CustomAudioStream extends StreamAudioSource {
//   late YoutubeExplode ytExplode;
//   StreamInfo? streamInfo;
//   String videoId;
//   String quality;

//   CustomAudioStream(this.videoId, this.quality, {super.tag}) {
//     ytExplode = YoutubeExplode();
//   }

//   Future _loadStreamInfo() async {
//     StreamManifest manifest =
//         await ytExplode.videos.streamsClient.getManifest(videoId);

//     List<AudioOnlyStreamInfo> streamInfos = manifest.audioOnly
//         .sortByBitrate()
//         .reversed
//         .where((stream) => stream.container == StreamContainer.mp4)
//         .toList();

//     int qualityIndex = quality == 'low' ? 0 : streamInfos.length - 1;
//     streamInfo = streamInfos[qualityIndex];
//     if (streamInfo!.fragments.isNotEmpty) {
//       print("Using DASH Fragmented Stream");
//     } else if (streamInfo is HlsStreamInfo) {
//       print("Using HLS Stream");
//     } else {
//       print("Using Normal Stream");
//     }
//     print(streamInfo!.url.toString());
//   }

//   @override
//   Future<StreamAudioResponse> request([int? start, int? end]) async {
//     if (streamInfo == null) {
//       await _loadStreamInfo();
//     }

//     start ??= 0;

//     int size = 10379935;
//     end = start + size.clamp(0, streamInfo!.size.totalBytes - start);
//     // if (!streamInfo!.isThrottled) {

//     // }
//     // end ??= streamInfo!.size.totalBytes;
//     if (end > streamInfo!.size.totalBytes) {
//       end = streamInfo!.size.totalBytes;
//     }
//     print('$start-$end');
//     final response = ytExplode.videos.streams.get(streamInfo!, start, end);

//     return StreamAudioResponse(
//       sourceLength: streamInfo!.size.totalBytes,
//       contentLength: null,
//       offset: null,
//       stream: response,
//       contentType: streamInfo!.codec.type,
//     );
//   }
// }
