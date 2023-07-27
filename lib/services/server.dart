import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

YoutubeExplode yt = YoutubeExplode();
Future<HttpServer> startServer() async {
  ServerSocket socket =
      await ServerSocket.bind(InternetAddress.loopbackIPv4, 8080);

  HttpServer s = HttpServer.listenOn(socket);
  s.listen((HttpRequest req) async {
    String id = req.uri.queryParameters['id'] ?? 'lx6i9hURwyQ';
    String quality =
        (req.uri.queryParameters['quality'] ?? 'Medium').toLowerCase();
    int qualityIndex = 0;

    StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
    List<AudioOnlyStreamInfo> streamInfos =
        manifest.audioOnly.sortByBitrate().reversed.toList();
    if (quality == 'low') {
      qualityIndex = 0;
    } else if (quality == 'medium') {
      qualityIndex = (streamInfos.length / 2).floor();
    } else {
      qualityIndex = streamInfos.length - 1;
    }
    AudioOnlyStreamInfo streamInfo = streamInfos[qualityIndex];

    Stream<List<int>> stream = yt.videos.streamsClient.get(streamInfo);
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
