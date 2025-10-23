import 'package:drift/drift.dart';

enum SettingType { bool, int, string, color }

class SettingTypeConverter extends TypeConverter<SettingType, String> {
  const SettingTypeConverter();

  @override
  SettingType fromSql(String fromDb) {
    return SettingType.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(SettingType value) => value.name;
}


class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  TextColumn get type => text().map(const SettingTypeConverter())();

  @override
  Set<Column> get primaryKey => {key};
}