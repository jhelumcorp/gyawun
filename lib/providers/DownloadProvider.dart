import 'package:external_path/external_path.dart';
import 'package:file_support/file_support.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../Models/Track.dart';

class DownloadManager extends ChangeNotifier {
  Map items = {};
  String path = "/storage/emulated/0/Music/";

  getSong(videoId) => items[videoId];

  Future<bool> requestPermission() async {
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

  download(Track song) async {
    bool permission = await requestPermission();
    if (permission == false) {
      return false;
    }

    try {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_MUSIC);
    } catch (e) {
      print(e);
    }
    Box box = Hive.box('downloads');
    box.put(song.videoId,
        {...song.toMap(), 'progress': 0.00, 'status': 'starting'});
    String? url = await getAudioUri(song.videoId);

    await FileSupport()
        .downloadCustomLocation(
      url: url,
      filename: song.title,
      extension: '.mp3',
      path: path,
      progress: (p0) {
        String status = 'downloading';
        if (int.parse(p0) == 100) {
          status = 'done';
        }
        box.put(
          song.videoId,
          {...song.toMap(), 'progress': double.parse(p0), 'status': status},
        );
      },
    )
        .then((file) async {
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
    });
  }

  static Future<String?> getAudioUri(String videoId) async {
    Box box = Hive.box('settings');
    String audioQuality = box.get("audioQuality", defaultValue: 'medium');
    String audioUrl = '';
    try {
      YoutubeExplode _youtubeExplode = YoutubeExplode();
      final StreamManifest manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      List<AudioOnlyStreamInfo> audios = manifest.audioOnly.sortByBitrate();

      int audioNumber = audioQuality == 'low'
          ? 0
          : (audioQuality == 'high'
              ? audios.length - 1
              : (audios.length / 2).floor());

      audioUrl = audios[audioNumber].url.toString();

      return audioUrl;
    } catch (e) {
      return null;
    }
  }
}
