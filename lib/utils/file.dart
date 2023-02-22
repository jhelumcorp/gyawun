import 'dart:developer';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

deleteFile(videoId) async {
  try {
    Box box = Hive.box('downloads');
    Map? download = box.get(videoId);
    if (download != null) {
      File file = File(download['path']);
      await box.delete(videoId);
      bool fileExists = await file.exists();
      if (fileExists) {
        await file.delete();
      }
    }
  } catch (e) {
    log(e.toString());
  }
}
