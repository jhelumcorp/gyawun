import 'dart:io';
import 'dart:typed_data';

import 'package:al_downloader/al_downloader.dart';
import 'package:audio_service/audio_service.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

download(MediaItem song) async {
  String? item = Hive.box('downloads').get(song.id);
  if (item != null) {
    return;
  }
  bool status = await checkAndRequestPermissions();
  if (!status) return;
  final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
  String oldName = song.title.replaceAll(avoid, "");
  int downloadQuality =
      Hive.box('settings').get('downloadQuality', defaultValue: 160);
  String url = song.extras!['url']
      .toString()
      .replaceAll(RegExp('_92|_160|_320'), '_$downloadQuality');
  int count = 1;
  String name = oldName;
  while (await File('/storage/emulated/0/Music/$name.m4a').exists()) {
    name = '$oldName($count)';
    count++;
  }
  ALDownloader.download(
    url,
    directoryPath: '/storage/emulated/0/Music/',
    fileName: '$name.m4a',
    downloaderHandlerInterface: ALDownloaderHandlerInterface(
      progressHandler: (progress) {
        Hive.box('downloads').put(
            song.id, {'path': null, 'progress': progress, 'status': 'pending'});
      },
      succeededHandler: () async {
        File file = File('/storage/emulated/0/Music/$name.m4a');
        Response res = await get(song.artUri!);
        await getImageUri(song.id, res.bodyBytes);
        await MetadataGod.writeMetadata(
          file: file.path,
          metadata: Metadata(
            title: oldName,
            artist: song.artist,
            album: song.album,
            genre: song.genre,
            trackNumber: 1,
            year: int.parse(song.extras?['year'] ?? 0),
            fileSize: file.lengthSync(),
            picture: Picture(
              data: res.bodyBytes,
              mimeType: 'image/jpeg',
            ),
          ),
        );
        Hive.box('downloads').put(
            song.id, {'path': file.path, 'progress': 100, 'status': 'done'});
      },
      failedHandler: () {
        Hive.box('downloads').delete(song.id);
      },
    ),
  );
}

Future<bool> checkAndRequestPermissions() async {
  if (await Permission.audio.status.isDenied &&
      await Permission.storage.status.isDenied) {
    await [Permission.audio, Permission.storage].request();

    if (await Permission.audio.status.isDenied &&
        await Permission.storage.status.isDenied) {
      await openAppSettings();
    }
  }

  // try {
  //   File file = await File('/storage/emulated/0/Music/gyavun.txt').create();
  //   if (await file.exists()) {
  //     await file.delete();
  //     return true;
  //   }
  // } catch (err) {
  //   status = await Permission.storage.request();

  //   if (status.isDenied) {
  //     status = await Permission.storage.request();
  //     if (status.isPermanentlyDenied) {
  //       await openAppSettings();
  //     }
  //   }
  // }

  return await Permission.storage.isGranted || await Permission.audio.isGranted;
}

Future<MediaItem> processSong(Map song) async {
  Map? downloaded = Hive.box('downloads').get(song['id']);
  MediaItem mediaItem;
  if (downloaded != null && downloaded['status'] == 'done') {
    bool exists = await File(downloaded['path']).exists();
    if (!exists) {
      await Hive.box('downloads').delete(song['id']);
      int streamingQuality =
          Hive.box('settings').get('streamingQuality', defaultValue: 160);
      song['url'] =
          song['url'].toString().replaceAll('_96', '_$streamingQuality');
      return MediaItem(
        id: song['id'],
        title: song['title'],
        album: song['album'],
        artUri: Uri.parse(song['image']),
        artist: song['artist'],
        extras: Map.from(song),
      );
    }
    Metadata metadata =
        await MetadataGod.readMetadata(file: downloaded['path']);
    // File image = File.fromRawPath(metadata.picture!.data);
    Uri image = await getImageUri(song['id'], metadata.picture!.data);

    mediaItem = MediaItem(
      id: song['id'],
      title: metadata.title!,
      album: metadata.album,
      artUri: image,
      artist: metadata.artist,
      extras: {
        'id': song['id'],
        'url': downloaded['path'],
        'offline': true,
        'image': image.path,
        'artist': metadata.artist,
        'album': metadata.album,
        'title': metadata.title,
      },
    );
  } else {
    int streamingQuality =
        Hive.box('settings').get('streamingQuality', defaultValue: 160);
    song['url'] =
        song['url'].toString().replaceAll('_96', '_$streamingQuality');
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

Future<Uri> getImageUri(String id, Uint8List bytes) async {
  final tempDir = await getApplicationDocumentsDirectory();
  final file = File('${tempDir.path}/$id.jpg');
  bool exists = await file.exists();
  if (!exists) {
    await file.writeAsBytes(bytes);
  }
  return file.uri;
}
