import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'file_storage.dart';
import 'settings_manager.dart';
import 'stream_client.dart';

Box _box = Hive.box('DOWNLOADS');
YoutubeExplode ytExplode = YoutubeExplode();

class DownloadManager {
  Client client = Client();
  ValueNotifier<List<Map>> downloads = ValueNotifier([]);
  DownloadManager() {
    downloads.value = _box.values.toList().cast<Map>();
    _box.listenable().addListener(() {
      downloads.value = _box.values.toList().cast<Map>();
    });
  }
  Future<void> downloadSong(Map song) async {
    if (!(await FileStorage.requestPermissions())) {
      return;
    }
    AudioOnlyStreamInfo audioSource = await _getSongInfo(song['videoId'],
        quality: GetIt.I<SettingsManager>().downloadQuality.name.toLowerCase());
    int start = 0;
    int end = audioSource.size.totalBytes;
    Stream<List<int>> stream =
        AudioStreamClient().getAudioStream(audioSource, start: start, end: end);
    // HttpServer server = GetIt.I<HttpServer>();
    // StreamedResponse response = await client.send(
    //   Request(
    //     'GET',
    //     Uri.parse(
    //         'http://${server.address.address}:${server.port}?id=${song['videoId']}&quality=${GetIt.I<SettingsManager>().downloadQuality.name.toLowerCase()}'),
    //   ),
    // );
    int total = audioSource.size.totalBytes;
    List<int> recieved = [];
    await _box.put(
      song['videoId'],
      {
        ...song,
        'status': 'PROCESSING',
        'progress': 0,
      },
    );

    stream.listen(
      (data) async {
        recieved.addAll(data);
        await _box.put(
          song['videoId'],
          {
            ...song,
            'status': 'DOWNLOADING',
            'progress': (recieved.length / total) * 100,
          },
        );
      },
      onDone: () async {
        if (recieved.length == total) {
          File? file = await GetIt.I<FileStorage>().saveMusic(recieved, song);
          if (file?.path != null) {
            await _box.put(
              song['videoId'],
              {
                ...song,
                'status': 'DOWNLOADED',
                'progress': 100,
                'path': file!.path
              },
            );
          } else {
            await _box.delete(song['videoId']);
          }
        }
      },
      onError: (err) async {
        await _box.delete(song['videoId']);
      },
    );
  }

  Future<AudioOnlyStreamInfo> _getSongInfo(String videoId,
      {String quality = 'high'}) async {
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
    return streamInfos[qualityIndex];
  }

  Future<String> deleteSong(String key, String path) async {
    await _box.delete(key);
    await File(path).delete();
    return 'Song deleted successfully.';
  }

  updateStatus(String key, String status) {
    Map? song = _box.get(key);
    if (song != null) {
      song['status'] = status;
      _box.put(key, song);
    }
  }
}
