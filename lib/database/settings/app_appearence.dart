// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gyawun_music/providers/database_provider.dart';
// import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
// import 'package:rxdart/rxdart.dart';

// class AppAppearance {
//   final AppThemeMode themeMode;
//   final bool isPureBlack;
//   final bool enableSystemColors;
//   final Color? accentColor;

//   final AppLanguage language;

//   const AppAppearance({
//     required this.themeMode,
//     required this.isPureBlack,
//     required this.enableSystemColors,
//     required this.accentColor,
//     required this.language,
//   });

//   AppAppearance copyWith({
//     AppThemeMode? themeMode,
//     bool? isPureBlack,
//     bool? enableSystemColors,
//     Color? accentColor,
//     AppLanguage? language,
//     bool? isRightToLeft,
//   }) {
//     return AppAppearance(
//       themeMode: themeMode ?? this.themeMode,
//       isPureBlack: isPureBlack ?? this.isPureBlack,
//       enableSystemColors: enableSystemColors ?? this.enableSystemColors,
//       accentColor: accentColor ?? this.accentColor,
//       language: language ?? this.language,
//     );
//   }
// }

// class AppLanguage {
//   final String title;
//   final String value;

//   AppLanguage({required this.title, required this.value});
//   factory AppLanguage.fromJson(Map<String, dynamic> json) =>
//       AppLanguage(title: json['title'], value: json['value']);

//   Map<String, dynamic> toJson() => {'title': title, 'value': value};
// }

// class AppThemeMode {
//   final String text;
//   final ThemeMode mode;

//   AppThemeMode({required this.text, required this.mode});
// }

// Stream<AppAppearance> appAppearancehandler(Ref ref) {
//   final dao = ref.watch(appSettingsProvider);

//   final darkTheme$ = dao
//       .watchSetting<String>(AppSettingsIdentifiers.darkTheme)
//       .distinct();
//   final accentColor$ = dao
//       .watchSetting<Color?>(AppSettingsIdentifiers.accentColor)
//       .distinct();
//   final isPureBlack$ = dao
//       .watchSetting<bool>(AppSettingsIdentifiers.isPureBlack)
//       .distinct();
//   final enableSystemColors$ = dao
//       .watchSetting<bool>(AppSettingsIdentifiers.enableSystemColors)
//       .distinct();

//   final appLanguage$ = dao
//       .watchSetting<String>(AppSettingsIdentifiers.appLanguage)
//       .distinct();

//   return Rx.combineLatestList([
//     darkTheme$,
//     accentColor$,
//     isPureBlack$,
//     enableSystemColors$,
//     appLanguage$,
//   ]).map((values) {
//     final darkTheme = values[0] ?? 'system';
//     final accentColor = values[1] as Color?;
//     final isPureBlack = values[2] as bool? ?? false;
//     final enableSystemColors = values[3] as bool? ?? true;

//     final language = values[4] != null
//         ? jsonDecode(values[4] as String)
//         : (AppLanguage(title: "English", value: 'en').toJson());
//     final AppThemeMode mode;
//     switch (darkTheme) {
//       case 'on':
//         mode = AppThemeMode(text: "On", mode: ThemeMode.dark);
//         break;
//       case 'off':
//         mode = AppThemeMode(text: "Off", mode: ThemeMode.light);
//         break;
//       default:
//         mode = AppThemeMode(text: "Follow system", mode: ThemeMode.system);
//     }

//     return AppAppearance(
//       themeMode: mode,
//       accentColor: accentColor,
//       isPureBlack: isPureBlack,
//       enableSystemColors: enableSystemColors,
//       language: AppLanguage.fromJson(language),
//     );
//   });
// }
