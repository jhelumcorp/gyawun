import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibe_music/providers/TD.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../Models/Track.dart';

class DownloadManager extends ChangeNotifier {
  Map items = {};
  String path = "/storage/emulated/0/Music/";

  getSong(videoId) => items[videoId];

  Future<bool> requestPermission() async {
    bool status = await requestStoragePermission();
    bool manage = await requestManagePermission();
    return status && manage;
  }

  Future<bool> requestStoragePermission() async {
    Permission status = Permission.storage;
    if (await status.isGranted) {
      return true;
    }
    PermissionStatus permissionStatus = await status.request();
    if (permissionStatus.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> requestManagePermission() async {
    Permission status = Permission.manageExternalStorage;
    if (await status.isGranted) {
      return true;
    }
    PermissionStatus permissionStatus = await status.request();
    if (permissionStatus.isGranted) {
      return true;
    }
    return false;
  }

  download(Track song) async {
    bool permission = await requestPermission();
    if (permission == false) {
      return false;
    }

    Box box = Hive.box('downloads');
    box.put(song.videoId,
        {...song.toMap(), 'progress': 0.00, 'status': 'starting'});
    Map stream = await getAudioUri(song.videoId) ?? {};
    String url = stream['url'];

    await ChunkedDownloader(
      url: url,
      path: path,
      title: song.title,
      extension: 'mp3',
      chunkSize: 1024 * 64,
      onError: (error) {
        log(error.toString());
      },
      onProgress: (received, total, speed) {
        double p0 = (received / total) * 100;
        String status = 'downloading';
        if (p0 == 100) {
          status = 'done';
        }
        box.put(
          song.videoId,
          {...song.toMap(), 'progress': p0, 'status': status},
        );
      },
      onDone: (file) async {
        if (file != null) {
          box.put(
            song.videoId,
            {
              ...song.toMap(),
              'progress': 100.00,
              'status': 'done',
              'path': file.path
            },
          );
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
