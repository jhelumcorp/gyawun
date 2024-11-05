import 'dart:convert';
import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import '../utils/enhanced_image.dart';
import '../ytmusic/ytmusic.dart';
import 'library.dart';
import 'settings_manager.dart';

class FileStorage {
  static bool _initialised = false;
  static late StoragePaths _storagePaths;
  late StoragePaths storagePaths;
  FileStorage() {
    if (!_initialised) {
      throw 'file Storage is Not Initialised. try calling `await FileStorage.initialise()`';
    }
    storagePaths = _storagePaths;
  }

  static Future<void> initialise() async {
    Directory directory = Directory("dir");
    if (Platform.isAndroid) {
      directory = Directory(Hive.box('SETTINGS').get('APP_FOLDER',defaultValue:'/storage/emulated/0/Download/Gyawun'));
    } else if (Platform.isWindows) {
      directory =
          Directory(path.join((await getDownloadsDirectory())!.path, 'Gyawun'));
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    _storagePaths = StoragePaths(
      basePath: directory.path,
      backupPath: path.join(directory.path, 'Back Up'),
      musicPath: path.join(directory.path, 'Music'),
    );
    await _getDirectory(_storagePaths.backupPath);
    await _getDirectory(_storagePaths.musicPath);
    _initialised = true;
  }

  updateDirectories()async{
    Directory directory = Directory("dir");
    if (Platform.isAndroid) {
      directory = Directory(Hive.box('SETTINGS').get('APP_FOLDER',defaultValue:'/storage/emulated/0/Download')+'/Gyawun');
    } else if (Platform.isWindows) {
      directory =
          Directory(path.join((await getDownloadsDirectory())!.path, 'Gyawun'));
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
     storagePaths = StoragePaths(
      basePath: directory.path,
      backupPath: path.join(directory.path, 'Back Up'),
      musicPath: path.join(directory.path, 'Music'),
    );
    await _getDirectory(_storagePaths.backupPath);
    await _getDirectory(_storagePaths.musicPath);
    _initialised = true;
  }

  Future<File?> saveBackUp(Map data) async {
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = '${timestamp}_backup';
    if (!(await requestPermissions())) return null;
    Directory directory = await _getDirectory(storagePaths.backupPath);

    String filePath = path.join(directory.path, '$fileName.json');
    File file = File(filePath);
    try {
      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsString(jsonEncode(data), flush: true);
      return file;
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> saveMusic(List<int> data, Map song,{extension='m4a'}) async {
    String fileName = song['title'];
    final RegExp avoid = RegExp(r'[\.\\\*\:\(\)\"\?#/;\|]');
    fileName = fileName.replaceAll(avoid, '').replaceAll("'", '');
    //fileName = Uri.decodeFull(fileName);
    if (!(await requestPermissions())) return null;
    Directory directory = await _getDirectory(storagePaths.musicPath);

    File file = File(path.join(directory.path, '$fileName.$extension'));
    int number = 1;
    while (file.existsSync()) {
      file = File((path.join(directory.path, '$fileName($number).$extension')));
      number++;
    }
    try {
      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsBytes(data, flush: true);
      
      
      try{
        Response res = await get(
          Uri.parse(getEnhancedImage(song['thumbnails'].first['url'])));
      Tag tag = Tag(
          title: song['title'],
          trackArtist:
              song['artists']?.map((artist) => artist['name']).join(','),
          album: song['album']?['name'],
          pictures: [
            Picture(
              bytes: res.bodyBytes,
              pictureType: PictureType.coverFront,
            )
          ]);
        await AudioTags.write(file.path, tag);
      }catch(e){
        await file.writeAsBytes(data,flush: true);
      }
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadBackup(BuildContext context) async {
    if (!(await requestPermissions())) return;
    FilePickerResult? picker = await FilePicker.platform.pickFiles(
      initialDirectory: storagePaths.backupPath,
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picker == null) return;
    final file = picker.files[0].xFile;
    String data = await file.readAsString();
    Map backup = jsonDecode(data);
    if (backup['name'] != 'Gyawun' && backup['type'] != 'backup') {
      return;
    }
    Map? settings = backup['data']?['settings'];
    Map? favourites = backup['data']?['favourites'];
    Map? playlists = backup['data']?['playlists'];
    Map? history = backup['data']?['song_history'];
    Map? downloads = backup['data']?['downloads'];
    if (settings != null) {
      await GetIt.I<SettingsManager>().setSettings(settings);
      await GetIt.I<YTMusic>().refreshHeaders();
    }
    if (favourites != null) {
      await Future.forEach(favourites.entries, (entry) async {
        Hive.box('FAVOURITES').put(entry.key, entry.value);
      });
    }
    if (playlists != null) {
      await GetIt.I<LibraryService>().setPlaylists(playlists);
    }
    if (history != null) {
      await Future.forEach(history.entries, (entry) async {
        Hive.box('SONG_HISTORY').put(entry.key, entry.value);
      });
    }
    if (downloads != null) {
      await Future.forEach(downloads.entries, (entry) async {
        Hive.box('DOWNLOADS').put(entry.key, entry.value);
      });
    }
  }

  static Future<Directory> _getDirectory(String pathString) async {
    Directory dir = Directory(pathString);
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isWindows) return true;
    List<Permission> permissions = [
      Permission.manageExternalStorage,
      Permission.storage
    ];
    bool isGranted =
        (await Permission.manageExternalStorage.status.isGranted) ||
            (await Permission.storage.status.isGranted);
    if (isGranted) return true;
    await permissions.request();
    isGranted = (await Permission.manageExternalStorage.status.isGranted) ||
        (await Permission.storage.status.isGranted);
    if (!(isGranted)) {
      await openAppSettings();
    }
    return isGranted;
  }
}

class StoragePaths {
  String basePath;
  String backupPath;
  String musicPath;
  StoragePaths(
      {required this.basePath,
      required this.backupPath,
      required this.musicPath});
}
