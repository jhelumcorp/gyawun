import 'dart:developer';
import 'dart:io';
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
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied) {
      await [
        Permission.storage,
      ].request();
    }
    status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }
    log('Request permanently denied');
    await openAppSettings();
    status = await Permission.storage.status;

    return Permission.storage.status.isGranted;
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

    String filePath = '$path${song.title}.mp3';
    String artPath = '$appPath/${song.title}.jpg';
    Box box = Hive.box('downloads');

    Map stream = await getAudioUri(song.videoId) ?? {};
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
      title: song.title,
      extension: 'mp3',
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
    Box box = Hive.box('settings');
    String audioQuality = box.get("audioQuality", defaultValue: 'medium');
    String audioUrl = '';
    try {
      YoutubeExplode _youtubeExplode = YoutubeExplode();
      final StreamManifest manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);
      List<AudioStreamInfo> audios = manifest.audioOnly.sortByBitrate();

      int audioNumber = audioQuality == 'low'
          ? 0
          : (audioQuality == 'high'
              ? audios.length - 1
              : (audios.length / 2).floor());
      var item = audios[audioNumber];

      audioUrl = audios[audioNumber].url.toString();
      String extension = item.container.name;

      return {'url': audioUrl, 'extension': extension};
    } catch (e) {
      return null;
    }
  }
}
