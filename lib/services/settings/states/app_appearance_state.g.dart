// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_appearance_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAppearanceState _$AppAppearanceStateFromJson(Map<String, dynamic> json) =>
    AppAppearanceState(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
      accentColor: (json['accentColor'] as num).toInt(),
      enableDynamicTheme: json['enableDynamicTheme'] as bool,
      isPureBlack: json['isPureBlack'] as bool,
      enableSystemColors: json['enableSystemColors'] as bool,
      language: AppLanguage.fromJson(json['language'] as Map<String, dynamic>),
      enableAndroidPredictiveBack: json['enableAndroidPredictiveBack'] as bool,
      enableNewPlayer: json['enableNewPlayer'] as bool,
    );

Map<String, dynamic> _$AppAppearanceStateToJson(AppAppearanceState instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'accentColor': instance.accentColor,
      'enableDynamicTheme': instance.enableDynamicTheme,
      'isPureBlack': instance.isPureBlack,
      'enableSystemColors': instance.enableSystemColors,
      'language': instance.language,
      'enableAndroidPredictiveBack': instance.enableAndroidPredictiveBack,
      'enableNewPlayer': instance.enableNewPlayer,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
