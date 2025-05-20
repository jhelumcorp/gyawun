

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'utils.dart';

updateFlatpak(YamlMap packagingYaml,Logger log){
  final flatpakFile = File('packaging/flatpak/com.jhelum.gyawun.yaml');
  if (!flatpakFile.existsSync()) {
    log.severe('❌ packaging/flatpak/com.jhelum.gyawun.yaml not found.');
    exit(1);
  }
  final flatpakContent = flatpakFile.readAsStringSync();
  final flatpakEditor = YamlEditor(flatpakContent);
  try{
      flatpakEditor.update(['id'], packagingYaml['id']);
      flatpakEditor.update(['command'], packagingYaml['app_name']);

    } catch (e, stack) {
    log.severe('⚠️ Failed to update packaging/flatpak/com.jhelum.gyawun.yaml', e, stack);
    exit(1);
  }
  flatpakFile.writeAsStringSync(flatpakEditor.toString());
  log.info('✅ packaging/flatpak/com.jhelum.gyawun.yaml synced with packaging.yaml');
  
  copyFile(log,
    srcPath: 'packaging/src/gyawun.desktop',
    destDirPath: 'packaging/flatpak',
    name: 'gyawun.desktop'
  );
  copyFile(log,
    srcPath: 'packaging/src/icon-512x512.png',
    destDirPath: 'packaging/flatpak',
    name: 'com.jhelum.gyawun.png'
  );
}
