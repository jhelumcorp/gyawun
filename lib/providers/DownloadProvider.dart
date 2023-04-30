import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_support/file_support.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:vibe_music/providers/TD.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../Models/Track.dart';
import 'package:http/http.dart';

class DownloadManager extends ChangeNotifier {
  Map items = {};
  Map<String, ChunkedDownloader> managers = {};
  String path = "/storage/emulated/0/Music/";

  getSong(videoId) => items[videoId];
  ChunkedDownloader? getManager(videoId) => managers[videoId];
  get getSongs => items.values.toList();

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      log('Request denied');

      await Permission.storage.request();
    }
    status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    status = await Permission.manageExternalStorage.status;

    if (status.isPermanentlyDenied) {
      log('Request permanently denied');
      await openAppSettings();
    }
    bool manage = await Permission.manageExternalStorage.status.isGranted;
    bool storage = await Permission.storage.status.isGranted;
    return storage || manage;
  }

  isAndroidT() async {
    DeviceInfoPlugin dip = DeviceInfoPlugin();
    AndroidDeviceInfo info = await dip.androidInfo;
    return info.version.sdkInt >= 33;
  }

  download(Track song) async {
    items[song.videoId] = {
      ...song.toMap(),
      'progress': null,
      'status': 'starting'
    };
    notifyListeners();
    bool isGranted = await requestPermission();
    if (!isGranted) {
      items.remove(song.videoId);
      notifyListeners();
      return;
    }
    String appPath = (await getApplicationSupportDirectory()).path;

    Map stream = await getAudioUri(song.videoId) ?? {};
    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    String filePath =
        '$path${song.title.replaceAll(avoid, "")}.${stream['extension']}';
    String artPath = '$appPath/${song.title}.jpg';
    Box box = Hive.box('downloads');

    // items.remove(song.videoId);
    // return;
    String? url = stream['url'];
    if (url == null) {
      items.remove(song.videoId);
      return;
    }
    try {
      await File(filePath)
          .create(recursive: true)
          .then((value) => filePath = value.path);
      await File(artPath)
          .create(recursive: true)
          .then((value) => artPath = value.path);
    } catch (e) {
      log(e.toString());
      await [
        Permission.manageExternalStorage,
      ].request();
      await File(filePath)
          .create(recursive: true)
          .then((value) => filePath = value.path);
      await File(artPath)
          .create(recursive: true)
          .then((value) => artPath = value.path);
    }

    managers[song.videoId] = await ChunkedDownloader(
      url: url,
      path: path,
      title: song.title.replaceAll(avoid, ""),
      extension: stream['extension'],
      chunkSize: 1024 * 64,
      onError: (error) async {
        log(error.toString());
        await File(filePath).delete();
        await File(artPath).delete();
        items.remove(song.videoId);
        managers.remove(song.videoId);
      },
      onProgress: (received, total, speed) {
        double p0 = (received / total) * 100;
        String status = 'downloading';
        if (p0 == 100) {
          status = 'done';
        }
        items[song.videoId] = {
          ...song.toMap(),
          'progress': p0,
          'status': status
        };
        notifyListeners();
      },
      onDone: (file) async {
        Response res = await get(Uri.parse(
            'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}'));
        await File(artPath).writeAsBytes(res.bodyBytes);

        if (file != null) {
          box.put(
            song.videoId,
            {
              ...song.toMap(),
              'path': file.path,
              'art': artPath,
              'timestamp': DateTime.now().millisecondsSinceEpoch
            },
          );
          items.remove(song.videoId);
          managers.remove(song.videoId);
          notifyListeners();
        }
      },
      onPause: () {
        notifyListeners();
      },
      onResume: () {
        notifyListeners();
      },
      onCancel: () async {
        if (items[song.videoId] != null) {
          items.remove(song.videoId);
        }
        if (managers[song.videoId] != null) {
          managers.remove(song.videoId);
        }
        try {
          await File(artPath).delete();
        } catch (err) {
          log(err.toString());
        }
        try {
          await File(filePath).delete();
        } catch (err) {
          log(err.toString());
        }
      },
    ).start();
  }

  static Future<Map?> getAudioUri(String videoId) async {
    // Box box = Hive.box('settings');
    // String audioQuality = box.get("audioQuality", defaultValue: 'medium');
    String audioUrl = '';
    try {
      YoutubeExplode youtubeExplode = YoutubeExplode();
      final StreamManifest manifest =
          await youtubeExplode.videos.streamsClient.getManifest(videoId);

      audioUrl = manifest.audioOnly
          .where((element) => element.audioCodec.contains('opus'))
          .toList()
          .sortByBitrate()[0]
          .url
          .toString();
      String extension = 'mp3';

      return {'url': audioUrl, 'extension': extension};
    } catch (e) {
      return null;
    }
  }

  Future<Map?> getNewUrl(id) async {
    try {
      Response res = await get(
          Uri.parse("https://api.mrmonterrosa.site/ytdown/v1/?id=$id"));
      Map body = jsonDecode(res.body);
      String url = body['data']?['formats']?['mp3']?[0]?['url'];
      return {'url': url, 'extension': 'mp3'};
    } catch (e) {
      return null;
    }
  }
}
