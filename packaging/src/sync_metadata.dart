import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:logging/logging.dart';

import 'debian.dart';
import 'flatpak.dart';
import 'pubspec.dart';
import 'snapcraft.dart';

final log = Logger('GyawunMusic');

void main() {
  _setupLogging();

  final packagingFile = File('packaging/src/packaging.yaml');
  if (!packagingFile.existsSync()) {
    log.severe('❌ packaging.yaml not found.');
    exit(1);
  }

  final packagingYaml = loadYaml(packagingFile.readAsStringSync()) as YamlMap;
  updatePubspec(packagingYaml,log);
  updateDebian(packagingYaml,log);
  updateFlatpak(packagingYaml,log);
  updateSnapcraft(packagingYaml,log);

  log.info('✅ All files synced with packaging.yaml');

}






void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Customize log format
    final emoji = switch (record.level.name) {
      'INFO' => 'ℹ️',
      'WARNING' => '⚠️',
      'SEVERE' => '❌',
      _ => '🔸'
    };
    print('$emoji ${record.level.name}: ${record.message}');
  });
}