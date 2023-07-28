import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackCache extends ChangeNotifier {
  SharedPreferences? _sp;
  ValueNotifier<String> cachesize = ValueNotifier<String>('0.00 Mbs');

  PlaybackCache() {
    init();
  }
  init() async {
    _sp ??= await SharedPreferences.getInstance();
    await getCacheSize();
  }

  Future<bool> existedInLocal({required String url}) async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp!.getString(url) != null;
  }

  Future<void> cacheFile({required String url, String? path}) async {
    _sp ??= await SharedPreferences.getInstance();
    final dirPath = path ?? (await _openDir()).path;
    final storedPath = await _download(url: url, path: dirPath);
    if (storedPath != null) {
      _sp!.setString(url, storedPath);
      await getCacheSize();
    }
  }

  Future<String?> getFile({required String url, String? path}) async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp!.getString(url);
  }

  Future<void> clearCache({String? path}) async {
    final dir = path != null ? Directory(path) : (await _openDir());
    cachesize.value = '0.00 MBs';
    notifyListeners();
    await _sp!.clear();
    return dir.deleteSync(recursive: true);
  }

  Future getCacheSize({String? path}) async {
    String dir = path ?? (await _openDir()).path;
    var files = await Directory(dir).list(recursive: true).toList();
    var dirSize = files.fold(0, (int sum, file) => sum + file.statSync().size);

    String csize = '${(dirSize / 1024 / 1024).toStringAsFixed(2)} MBs';
    cachesize.value = csize;
    notifyListeners();
  }

  Future<String?> _download({required String url, required String path}) async {
    try {
      final res = await http.get(
        Uri.parse(url),
      );
      if (res.statusCode == 200) {
        final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
        final bytes = res.bodyBytes;
        final file = File('$path/${url.replaceAll(avoid, '')}');
        await file.writeAsBytes(bytes);
        return file.path;
      } else {
        return null;
      }
    } on IOException catch (e) {
      Logger.root.info('Error occurs while downloading file: $e');
      return null;
    } catch (e) {
      Logger.root.info(e);
      return null;
    }
  }

  Future<Directory> _openDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory('${dir.path}/audio_cache');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
    }
    return targetDir;
  }
}
