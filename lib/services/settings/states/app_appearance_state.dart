import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/app_language.dart';

part 'app_appearance_state.g.dart';

@JsonSerializable()
class AppAppearanceState {
  factory AppAppearanceState.fromJson(Map<String, dynamic> json) =>
      _$AppAppearanceStateFromJson(json);
  const AppAppearanceState({
    required this.themeMode,
    required this.accentColor,
    required this.enableDynamicTheme,
    required this.isPureBlack,
    required this.enableSystemColors,
    required this.language,
    required this.enableAndroidPredictiveBack,
    required this.enableNewPlayer,
  });
  final ThemeMode themeMode;
  final int accentColor; // Store color as int
  final bool enableDynamicTheme;
  final bool isPureBlack;
  final bool enableSystemColors;
  final AppLanguage language;
  final bool enableAndroidPredictiveBack;
  final bool enableNewPlayer;

  AppAppearanceState copyWith({
    ThemeMode? themeMode,
    int? accentColor,
    bool? enableDynamicTheme,
    bool? isPureBlack,
    bool? enableSystemColors,
    AppLanguage? language,
    bool? enableAndroidPredictiveBack,
    bool? enableNewPlayer,
  }) {
    return AppAppearanceState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      enableDynamicTheme: enableDynamicTheme ?? this.enableDynamicTheme,
      isPureBlack: isPureBlack ?? this.isPureBlack,
      enableSystemColors: enableSystemColors ?? this.enableSystemColors,
      language: language ?? this.language,
      enableAndroidPredictiveBack: enableAndroidPredictiveBack ?? this.enableAndroidPredictiveBack,
      enableNewPlayer: enableNewPlayer ?? this.enableNewPlayer,
    );
  }

  Map<String, dynamic> toJson() => _$AppAppearanceStateToJson(this);
}
