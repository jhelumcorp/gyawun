import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:gyawun_music/database/database.dart';
import 'app_settings.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class AppSettingsTableDao extends DatabaseAccessor<AppSettingsDatabase>
    with _$AppSettingsTableDaoMixin {
  AppSettingsTableDao(super.db);

  Future<int> _setSetting(String key, String value, SettingType type) {
    return into(appSettingsTable).insertOnConflictUpdate(
      AppSettingsTableCompanion(
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

  // Generic setter - automatically dispatches to the correct type-specific setter
  Future<int> setSetting<T>(String key, T value) {
    if (value is bool) return setBool(key, value);
    if (value is int) return setInt(key, value);
    if (value is String) return setString(key, value);
    if (value is Color) return setColor(key, value);
    throw ArgumentError('Unsupported setting type: ${value.runtimeType}');
  }

  T? _parseSettingValue<T>(AppSettingsTableData? row) {
    if (row == null) return null;

    switch (row.type) {
      case SettingType.bool:
        return bool.tryParse(row.value) as T?;
      case SettingType.int:
        return int.tryParse(row.value) as T?;
      case SettingType.color:
        final c = int.tryParse(row.value);
        return (c == null ? null : Color(c)) as T?;
      case SettingType.string:
        return (row.value.isNotEmpty ? row.value : null) as T?;
    }
  }

  Stream<T?> watchSetting<T>(String key) {
    return (select(appSettingsTable)..where((tbl) => tbl.key.equals(key)))
        .watchSingleOrNull()
        .map(_parseSettingValue<T>);
  }

  Future<T?> getSetting<T>(String key) async {
    final row = await (select(
      appSettingsTable,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();

    return _parseSettingValue<T>(row);
  }
}
