import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'settings/app_settings.dart';
import 'settings/app_settings_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [AppSettingsTable], daos: [AppSettingsTableDao])
class AppSettingsDatabase extends _$AppSettingsDatabase {
  AppSettingsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_settings.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
