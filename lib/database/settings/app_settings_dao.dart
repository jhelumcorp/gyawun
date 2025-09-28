import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:gyawun_music/database/database.dart';
import 'app_settings.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  Future<int> _setSetting(String key, String value, SettingType type) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        key: Value(key),
        value: Value(value),
        type: Value(type),
      ),
    );
  }

  Future<int> setBool(String key, bool value) {
    return _setSetting(key, value.toString(), SettingType.bool);
  }

  Future<int> setInt(String key, int value) =>
      _setSetting(key, value.toString(), SettingType.int);

  Future<int> setString(String key, String value) =>
      _setSetting(key, value, SettingType.string);

  Future<int> setColor(String key, Color color) =>
      _setSetting(key, color.toARGB32().toString(), SettingType.color);

  Stream<T?> watchSetting<T>(String key) {
    return (select(
      appSettings,
    )..where((tbl) => tbl.key.equals(key))).watchSingleOrNull().map((row) {
      if (row == null) return null;
      switch (row.type) {
        case SettingType.bool:
          return (bool.tryParse(row.value)) as T?;
        case SettingType.int:
          return int.tryParse(row.value) as T?;
        case SettingType.color:
          final c = int.tryParse(row.value);
          return c == null ? null : Color(c) as T?;
        case SettingType.string:
          return (row.value.isNotEmpty ? row.value : null) as T?;
      }
    });
  }
}
