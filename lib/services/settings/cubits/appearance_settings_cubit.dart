import 'package:flutter/material.dart';
import 'package:gyawun_music/services/settings/states/app_appearance_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/app_language.dart';

class AppearanceSettingsCubit extends HydratedCubit<AppAppearanceState> {
  AppearanceSettingsCubit()
    : super(
        AppAppearanceState(
          themeMode: ThemeMode.system,
          accentColor: Colors.blue.toARGB32(),
          enableDynamicTheme: true,
          isPureBlack: false,
          enableSystemColors: true,
          language: AppLanguage(title: 'English', value: 'en'),
          enableAndroidPredictiveBack: true,
          enableNewPlayer: false,
        ),
      );

  // -------------------------------------------------
  //  SETTERS
  // -------------------------------------------------

  /// Accepts 'on', 'off', 'system' (matches your dialog values)
  void setDarkTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  /// Accent color from dialog (Color)
  void setAccentColor(Color color) {
    emit(state.copyWith(accentColor: color.toARGB32()));
  }

  /// Dynamic theme toggle
  void setEnableDynamicTheme(bool value) {
    emit(state.copyWith(enableDynamicTheme: value));
  }

  /// Pure black toggle
  void setIsPureBlack(bool value) {
    emit(state.copyWith(isPureBlack: value));
  }

  /// System-wide colors toggle
  void setEnableSystemColors(bool value) {
    emit(state.copyWith(enableSystemColors: value));
  }

  /// Language selection
  void setAppLanguage(AppLanguage lang) {
    emit(state.copyWith(language: lang));
  }

  /// Predictive back gesture
  void setEnableAndroidPredictiveBack(bool value) {
    emit(state.copyWith(enableAndroidPredictiveBack: value));
  }

  /// New experimental player toggle
  void setEnableNewPlayer(bool value) {
    emit(state.copyWith(enableNewPlayer: value));
  }

  // -------------------------------------------------
  //  HYDRATE
  // -------------------------------------------------

  @override
  AppAppearanceState? fromJson(Map<String, dynamic> json) => AppAppearanceState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppAppearanceState state) => state.toJson();
}
