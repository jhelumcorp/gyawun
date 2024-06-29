library ytmusic;

import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'mixins/browsing.dart';
import 'mixins/search.dart';
import 'yt_service_provider.dart';

class YTMusic extends YTMusicServices with BrowsingMixin, SearchMixin {
  static final YoutubeExplode _yt = YoutubeExplode();

  static Future<HttpServer> startServer() async {
    ServerSocket socket =
        await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);

    HttpServer s = HttpServer.listenOn(socket);
    s.listen((HttpRequest req) async {
      String id = req.uri.queryParameters['id'] ?? 'lx6i9hURwyQ';
      String quality =
          (req.uri.queryParameters['quality'] ?? 'high').toLowerCase();
      int qualityIndex = 0;

      StreamManifest manifest = await _yt.videos.streamsClient.getManifest(id);
      List<AudioOnlyStreamInfo> streamInfos = manifest.audioOnly
          .sortByBitrate()
          .reversed
          .where((stream) => stream.container == StreamContainer.mp4)
          .toList();

      if (quality == 'low') {
        qualityIndex = 0;
      } else {
        qualityIndex = streamInfos.length - 1;
      }
      AudioOnlyStreamInfo streamInfo = streamInfos[qualityIndex];

      Stream<List<int>> stream = _yt.videos.streamsClient.get(streamInfo);
      req.response.statusCode = HttpStatus.ok;
      req.response.headers.contentType =
          ContentType.parse(streamInfo.codec.mimeType);
      req.response.contentLength = streamInfo.size.totalBytes;
      req.response.addStream(stream).whenComplete(() {
        req.response.close();
      });
    });
    return s;
  }

  // static getData() async {
  //   StreamManifest manifest =
  //       await _yt.videos.streamsClient.getManifest('9ssQKlLxBdQ');
  //   List<AudioOnlyStreamInfo> streamInfos =
  //       manifest.audioOnly.sortByBitrate().reversed.toList();
  //   pprint(streamInfos
  //       .where((stream) => stream.container == StreamContainer.mp4)
  //       .toList());
  // }
}
