import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gyawun_music/database/settings/app_settings_dao.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceSettings {
  AppearanceSettings(this._dao);
  final AppSettingsTableDao _dao;

  // Individual Getters
  Future<String?> get darkTheme =>
      _dao.getSetting<String>(AppSettingsIdentifiers.darkTheme);

  Future<Color?> get accentColor =>
      _dao.getSetting<Color>(AppSettingsIdentifiers.accentColor);

  Future<bool?> get isPureBlack =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.isPureBlack);

  Future<bool?> get enableSystemColors =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.enableSystemColors);

  Future<String?> get appLanguage =>
      _dao.getSetting<String>(AppSettingsIdentifiers.appLanguage);

  Future<bool?> get enableAndroidPredictiveBack =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.enableAndroidPredictiveBack);

  Future<bool?> get enableNewPlayer =>
      _dao.getSetting<bool>(AppSettingsIdentifiers.enableNewPlayer);

  // Individual Streams
  Stream<String?> get darkThemeStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.darkTheme).distinct();

  Stream<Color?> get accentColorStream =>
      _dao.watchSetting<Color>(AppSettingsIdentifiers.accentColor).distinct();

  Stream<bool?> get isPureBlackStream =>
      _dao.watchSetting<bool>(AppSettingsIdentifiers.isPureBlack).distinct();

  Stream<bool?> get enableSystemColorsStream => _dao
      .watchSetting<bool>(AppSettingsIdentifiers.enableSystemColors)
      .distinct();

  Stream<String?> get appLanguageStream =>
      _dao.watchSetting<String>(AppSettingsIdentifiers.appLanguage).distinct();

  Stream<bool?> get enableAndroidPredictiveBackStream => _dao
      .watchSetting<bool>(AppSettingsIdentifiers.enableAndroidPredictiveBack)
      .distinct();

  Stream<bool?> get enableNewPlayerStream => _dao
      .watchSetting<bool>(AppSettingsIdentifiers.enableNewPlayer)
      .distinct();

  // Combined Stream (for convenience - returns the complete AppAppearance object)
  Stream<AppAppearance> get stream {
    return Rx.combineLatestList([
      darkThemeStream,
      accentColorStream,
      isPureBlackStream,
      enableSystemColorsStream,
      appLanguageStream,
      enableAndroidPredictiveBackStream,
      enableNewPlayerStream,
    ]).map((values) {
      final darkTheme = values[0] ?? 'system';
      final accentColor = values[1] as Color?;
      final isPureBlack = values[2] as bool? ?? false;
      final enableSystemColors = values[3] as bool? ?? true;

      final language = values[4] != null
          ? jsonDecode(values[4] as String)
          : (AppLanguage(title: "English", value: 'en').toJson());
      final enableAndroidPredictiveBack = values[5] as bool? ?? false;
      final enableNewPlayer = values[6] as bool? ?? false;

      final AppThemeMode mode;
      switch (darkTheme) {
        case 'on':
          mode = AppThemeMode(text: "On", mode: ThemeMode.dark);
          break;
        case 'off':
          mode = AppThemeMode(text: "Off", mode: ThemeMode.light);
          break;
        default:
          mode = AppThemeMode(text: "Follow system", mode: ThemeMode.system);
      }

      return AppAppearance(
        themeMode: mode,
        accentColor: accentColor,
        isPureBlack: isPureBlack,
        enableSystemColors: enableSystemColors,
        enableAndroidPredictiveBack: enableAndroidPredictiveBack,
        language: AppLanguage.fromJson(language),
        enableNewPlayer: enableNewPlayer,
      );
    });
  }

  // Setters
  Future<void> setDarkTheme(String value) =>
      _dao.setSetting(AppSettingsIdentifiers.darkTheme, value);

  Future<void> setAccentColor(Color value) =>
      _dao.setSetting(AppSettingsIdentifiers.accentColor, value);

  Future<void> setIsPureBlack(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.isPureBlack, value);

  Future<void> setEnableSystemColors(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.enableSystemColors, value);

  Future<void> setAppLanguage(AppLanguage language) => _dao.setSetting(
    AppSettingsIdentifiers.appLanguage,
    jsonEncode(language.toJson()),
  );

  Future<void> setEnableAndroidPredictiveBack(bool value) => _dao.setSetting(
    AppSettingsIdentifiers.enableAndroidPredictiveBack,
    value,
  );

  Future<void> setEnableNewPlayer(bool value) =>
      _dao.setSetting(AppSettingsIdentifiers.enableNewPlayer, value);
}

class AppAppearance {
  const AppAppearance({
    required this.themeMode,
    required this.isPureBlack,
    required this.enableSystemColors,
    required this.accentColor,
    required this.language,
    required this.enableAndroidPredictiveBack,
    required this.enableNewPlayer,
  });
  final AppThemeMode themeMode;
  final bool isPureBlack;
  final bool enableSystemColors;
  final Color? accentColor;
  final bool enableAndroidPredictiveBack;
  final bool enableNewPlayer;
  final AppLanguage language;

  AppAppearance copyWith({
    AppThemeMode? themeMode,
    bool? isPureBlack,
    bool? enableSystemColors,
    Color? accentColor,
    AppLanguage? language,
    bool? enableAndroidPredictiveBack,
    bool? enableNewPlayer,
  }) {
    return AppAppearance(
      themeMode: themeMode ?? this.themeMode,
      isPureBlack: isPureBlack ?? this.isPureBlack,
      enableSystemColors: enableSystemColors ?? this.enableSystemColors,
      accentColor: accentColor ?? this.accentColor,
      language: language ?? this.language,
      enableAndroidPredictiveBack:
          enableAndroidPredictiveBack ?? this.enableAndroidPredictiveBack,
      enableNewPlayer: enableNewPlayer ?? this.enableNewPlayer,
    );
  }
}

class AppLanguage {
  AppLanguage({required this.title, required this.value});

  factory AppLanguage.fromJson(Map<String, dynamic> json) =>
      AppLanguage(title: json['title'], value: json['value']);
  final String title;
  final String value;

  Map<String, dynamic> toJson() => {'title': title, 'value': value};
}

class AppThemeMode {
  AppThemeMode({required this.text, required this.mode});
  final String text;
  final ThemeMode mode;
}
