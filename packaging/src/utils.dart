import 'dart:io';

import 'package:logging/logging.dart';

void copyFile(Logger log,{required String srcPath,required String destDirPath,required String name}) {
  log.info('Moving $srcPath file to $destDirPath');
  final destPath = '$destDirPath/$name';

  final srcFile = File(srcPath);
  final destDir = Directory(destDirPath);

  if (!srcFile.existsSync()) {
    log.severe('❌ File not found at $srcPath');
    exit(1);
  }

  try {
    if (!destDir.existsSync()) {
      destDir.createSync(recursive: true);
      log.info('✅ Created directory $destDirPath');
    }

    // Use copySync to keep source, or renameSync to move
    srcFile.copySync(destPath);
    log.info('✅ File copied to $destPath');
  } catch (e, stack) {
    log.severe('⚠️ Failed to copy File', e, stack);
    exit(1);
  }
}
