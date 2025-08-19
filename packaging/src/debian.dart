import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

import 'utils.dart';

void updateDebian(YamlMap packagingYaml,Logger log) {
  final controlFile = File('packaging/debian/DEBIAN/control');

  final content = '''
Package: ${packagingYaml['app_name']}
Version: ${packagingYaml['version']}
Section: sound
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libmpv-dev
Maintainer: ${packagingYaml['maintainer'] ?? 'Unknown <unknown@example.com>'}
Description: ${packagingYaml['summary'] ?? packagingYaml['description']}
 ${packagingYaml['description']}
''';

  try {
    controlFile.createSync(recursive: true);
    controlFile.writeAsStringSync('${content.trimRight()}\n');
    log.info('✅ packaging/debian/DEBIAN/control generated from packaging.yaml');
  } catch (e, stack) {
    log.severe('⚠️ Failed to generate control file', e, stack);
    exit(1);
  }
  copyFile(log,
    srcPath: 'packaging/src/gyawun.desktop',
    destDirPath: 'packaging/debian/usr/share/applications',
    name: 'gyawun.desktop'
  );
  copyFile(log,
    srcPath: 'packaging/src/icon-512x512.png',
    destDirPath: 'packaging/debian/usr/share/icons/hicolor/512x512/apps',
    name: 'com.jhelum.gyawun.png'
  );
}