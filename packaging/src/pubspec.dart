import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void updatePubspec(YamlMap packagingYaml,Logger log) {
  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    log.severe('❌ pubspec.yaml not found.');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecEditor = YamlEditor(pubspecContent);

  try {
    pubspecEditor.update(['name'], packagingYaml['app_name']);
    pubspecEditor.update(
      ['version'],
      packagingYaml['build'] != null
          ? '${packagingYaml['version']}+${packagingYaml['build']}'
          : packagingYaml['version'],
    );
    pubspecEditor.update(['description'], packagingYaml['description']);
  } catch (e, stack) {
    log.severe('⚠️ Failed to update pubspec.yaml', e, stack);
    exit(1);
  }

  pubspecFile.writeAsStringSync(pubspecEditor.toString());
  log.info('✅ pubspec.yaml synced with packaging.yaml');
}