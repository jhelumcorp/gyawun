import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
// import 'package:audiotags/audiotags.dart' as tags;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

YoutubeExplode yt = YoutubeExplode();
download(MediaItem song) async {
  String? item = Hive.box('downloads').get(song.id);
  if (item != null) {
    return;
  }
  if (Platform.isAndroid) {
    bool status = await checkAndRequestPermissions();
    if (!status) return;
  }
  final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
  String oldName = song.title.replaceAll(avoid, "");

  int count = 1;
  String name = oldName;
  String path = Platform.isAndroid
      ? '/storage/emulated/0/Music'
      : (await getDownloadsDirectory())!.path.replaceAll('Downloads', 'Music');
  while (await File('$path/$name.m4a').exists()) {
    name = '$oldName($count)';
    count++;
  }

  final client = Client();
  Stream<List<int>> stream;
  int total = 0;
  int recieved = 0;
  if (song.extras!['provider'] == 'youtube') {
    String id = song.id.replaceFirst('youtube', '');
    StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
    int qualityIndex = 0;
    List<AudioOnlyStreamInfo> streamInfos =
        manifest.audioOnly.sortByBitrate().reversed.toList();

    String quality = (Hive.box('settings')
            .get('youtubeDownloadQuality', defaultValue: 'Medium'))
        .toString()
        .toLowerCase();
    if (quality == 'low') {
      qualityIndex = 0;
    } else if (quality == 'medium') {
      qualityIndex = (streamInfos.length / 2).floor();
    } else {
      qualityIndex = streamInfos.length - 1;
    }
    AudioOnlyStreamInfo streamInfo = streamInfos[qualityIndex];
    total = streamInfo.size.totalBytes;
    stream = yt.videos.streamsClient.get(streamInfo);
  } else {
    int downloadQuality =
        Hive.box('settings').get('downloadQuality', defaultValue: 160);
    String url = song.extras!['url']
        .toString()
        .replaceAll(RegExp('_92|_160|_320'), '_$downloadQuality');

    final response = await client.send(Request('GET', Uri.parse(url)));
    total = response.contentLength ?? 0;
    stream = response.stream;
  }

  Logger.root.info('Client connected, Starting download');
  stream.asBroadcastStream();
  Logger.root.info('broadcasting download state');
  List<int> bytes = [];
  stream.listen((value) {
    bytes.addAll(value);
    try {
      recieved += value.length;
      Hive.box('downloads').put(song.id,
          {'path': null, 'progress': recieved / total, 'status': 'pending'});
    } catch (e) {
      Logger.root.severe('Error in download: $e');
    }
  }).onDone(() async {
    client.close();
    String localPath = path;
    String filePath = '$localPath/$name.m4a';
    File fileDef = File(filePath);

    await fileDef.writeAsBytes(bytes);
    Response res = await get(song.artUri!);
    await saveImage(song.id, res.bodyBytes);
    if (Platform.isAndroid) {
      await MetadataGod.writeMetadata(
        file: fileDef.path,
        metadata: Metadata(
            title: oldName,
            artist: song.artist ?? '',
            album: song.album ?? '',
            genre: song.genre ?? '',
            picture: Picture(mimeType: 'image/png', data: res.bodyBytes)),
      );
    }
    Map newsong = Map.from(song.extras ?? {});
    newsong['palette'] = null;
    Hive.box('downloads').put(song.id,
        {'path': fileDef.path, 'progress': 100, 'status': 'done', ...newsong});
  });
}

Future<bool> checkAndRequestPermissions() async {
  if (await Permission.audio.status.isDenied &&
      await Permission.storage.status.isDenied) {
    await [Permission.audio, Permission.storage].request();
    await Permission.manageExternalStorage.request();
    if (await Permission.audio.status.isDenied &&
        await Permission.storage.status.isDenied &&
        await Permission.manageExternalStorage.isDenied) {
      await openAppSettings();
    }
  }

  return await Permission.storage.isGranted ||
      await Permission.audio.isGranted ||
      await Permission.manageExternalStorage.isGranted;
}

Future<MediaItem> processSong(Map song) async {
  Map? downloaded = Hive.box('downloads').get(song['id']);
  MediaItem mediaItem;
  if (downloaded != null &&
      downloaded['status'] == 'done' &&
      await File(downloaded['path']).exists()) {
    Uri image = await getImageUri(song['id']);

    mediaItem = MediaItem(
      id: downloaded['id'],
      title: downloaded['title'],
      album: downloaded['album'],
      artUri: image,
      artist: downloaded['artist'],
      extras: {
        'id': downloaded['id'],
        'url': downloaded['path'],
        'offline': true,
        'image': image.path,
        'artist': downloaded['artist'],
        'album': downloaded['album'],
        'title': downloaded['title'],
      },
    );
  } else {
    if (song['provider'] != 'youtube') {
      int streamingQuality =
          Hive.box('settings').get('streamingQuality', defaultValue: 160);
      song['url'] =
          song['url'].toString().replaceAll('_96', '_$streamingQuality');
    }

    mediaItem = MediaItem(
      id: song['id'],
      title: song['title'],
      album: song['album'],
      artUri: Uri.parse(song['image']),
      artist: song['artist'],
      extras: Map.from(song),
    );
  }

  return mediaItem;
}

Future<void> deleteSong({dynamic key, String path = ""}) async {
  File file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
  Hive.box('downloads').delete(key);
  file = File('${(await getApplicationDocumentsDirectory()).path}/$key.jpg');
  if (await file.exists()) {
    await file.delete();
  }
}

Future<Uri> getImageUri(String id) async {
  final tempDir = Platform.isAndroid
      ? (await getApplicationDocumentsDirectory()).path
      : (await getDownloadsDirectory())!
          .path
          .replaceAll('Downloads', 'Music/.Thumbnails');
  final file = await File('$tempDir/$id.jpg').create(recursive: true);

  return file.uri;
}

Future<String?> saveImage(String id, Uint8List bytes) async {
  final tempDir = Platform.isAndroid
      ? (await getApplicationDocumentsDirectory()).path
      : (await getDownloadsDirectory())!
          .path
          .replaceAll('Downloads', 'Music/.Thumbnails');
  final file = await File('$tempDir/$id.jpg').create(recursive: true);
  try {
    await file.writeAsBytes(bytes);
    return file.path;
  } catch (err) {
    log(err.toString());
    return null;
  }
}

Future<String> getSongUrl(
  String id,
) async {
  String quality = Hive.box('settings')
      .get('youtubeStreamingQuality', defaultValue: 'Medium');

  id = id.replaceFirst('youtube', '');
  return 'http://${InternetAddress.loopbackIPv4.host}:8080?id=$id&q=$quality';
}

Future<String?> downloadYoutubeSong(MediaItem song, String path) async {
  Hive.box('downloads').put(song.id, {
    'path': null,
    'progress': 0.0,
    'status': 'pending',
    ...song.extras ?? {}
  });
  String id = song.id.replaceFirst('youtube', '');
  StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  int qualityIndex = 0;
  List<AudioOnlyStreamInfo> streamInfos =
      manifest.audioOnly.sortByBitrate().reversed.toList();
  String quality = (Hive.box('settings')
          .get('youtubeDownloadQuality', defaultValue: 'Medium'))
      .toString()
      .toLowerCase();
  if (quality == 'low') {
    qualityIndex = 0;
  } else if (quality == 'medium') {
    qualityIndex = (streamInfos.length / 2).floor();
  } else {
    qualityIndex = streamInfos.length - 1;
  }
  AudioOnlyStreamInfo streamInfo = streamInfos[qualityIndex];
  Stream<List<int>> stream = yt.videos.streamsClient.get(streamInfo);
  var file = await File(path).create();

  Response res = await get(song.artUri!);
  String? image = await saveImage(song.id, res.bodyBytes);
  int total = streamInfo.size.totalBytes;
  stream.asBroadcastStream();
  List<int> recieved = [];
  stream.listen((element) async {
    recieved.addAll(element);
    await Hive.box('downloads').put(song.id, {
      'path': file.path,
      'progress': (recieved.length / total) * 100,
      'status': recieved.length == total ? 'done' : 'pending',
      ...song.extras ?? {}
    });
  }).onDone(() async {
    await file.writeAsBytes(recieved);
    await Hive.box('downloads').put(song.id, {
      'path': file.path,
      'progress': 100,
      'status': 'done',
      ...song.extras ?? {}
    });
  });

  // Pipe all the content of the stream into the file.
  try {} catch (err) {
    Hive.box('downloads').delete(song.id);
  }
  return image;
}
