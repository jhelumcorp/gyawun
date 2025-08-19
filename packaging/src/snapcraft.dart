import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'utils.dart';

updateSnapcraft(YamlMap packagingYaml,Logger log){
  final snapcraftFile = File('snap/snapcraft.yaml');
  if (!snapcraftFile.existsSync()) {
    log.severe('❌ snap/snapcraft.yaml not found.');
    exit(1);
  }
  final snapcraftContent = snapcraftFile.readAsStringSync();
  final snapcraftEditor = YamlEditor(snapcraftContent);
  try{
      snapcraftEditor.update(['name'], packagingYaml['app_name']);
      snapcraftEditor.update(['version'], packagingYaml['version']);
      snapcraftEditor.update(['summary'], packagingYaml['summary']);
      snapcraftEditor.update(['description'], packagingYaml['description']);
    } catch (e, stack) {
    log.severe('⚠️ Failed to update snap/snapcraft.yaml', e, stack);
    exit(1);
  }
  snapcraftFile.writeAsStringSync(snapcraftEditor.toString());
  log.info('✅ snap/snapcraft.yaml synced with packaging.yaml');

  copyFile(log,
    srcPath: 'packaging/src/gyawun.desktop',
    destDirPath: 'snap/gui',
    name: 'gyawun.desktop'
  );
  copyFile(log,
    srcPath: 'packaging/src/icon-512x512.png',
    destDirPath: 'snap/gui',
    name: 'com.jhelum.gyawun.png'
  );
}