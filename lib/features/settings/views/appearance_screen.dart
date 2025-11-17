import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/settings/cubits/appearance_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/app_appearance_state.dart';

import '../../../services/settings/models/app_language.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().appearance;

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: BlocBuilder<AppearanceSettingsCubit, AppAppearanceState>(
        bloc: cubit,
        builder: (context, settings) {
          return SingleChildScrollView(
            child: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GroupTitle(title: "Theme", paddingTop: 0),

                      // Dark Theme
                      SettingTile(
                        title: "Dark theme",
                        leading: const Icon(FluentIcons.dark_theme_24_filled),
                        subtitle: settings.themeMode.name,
                        isFirst: true,
                        onTap: () => _handleDarkThemeChange(context),
                      ),

                      // Accent Color
                      SettingTile(
                        onTap: () => _handleAccentColorChange(context),
                        title: "Accent Color",
                        leading: const Icon(FluentIcons.color_24_filled),
                        trailing: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(settings.accentColor),
                        ),
                      ),

                      // Dynamic theme
                      SettingSwitchTile(
                        value: settings.enableDynamicTheme,
                        onChanged: cubit.setEnableDynamicTheme,
                        title: "Enable dynamic theme",
                        leading: const Icon(FluentIcons.color_background_24_filled),
                      ),

                      // Pure Black
                      SettingSwitchTile(
                        title: "Pure black",
                        leading: const Icon(FluentIcons.drop_24_filled),
                        value: settings.isPureBlack,
                        onChanged: cubit.setIsPureBlack,
                      ),

                      // System colors
                      SettingSwitchTile(
                        value: settings.enableSystemColors,
                        onChanged: cubit.setEnableSystemColors,
                        title: "Enable system colors",
                        leading: const Icon(FluentIcons.system_24_filled),
                        isLast: true,
                      ),

                      const GroupTitle(title: "Layout"),

                      // Language
                      SettingTile(
                        title: "Language",
                        leading: const Icon(FluentIcons.local_language_24_filled),
                        isFirst: true,
                        isLast: !Platform.isAndroid,
                        subtitle: settings.language.title,
                        onTap: () => _handleLanguageChange(context),
                      ),

                      // Predictive back
                      if (Platform.isAndroid)
                        SettingSwitchTile(
                          value: settings.enableAndroidPredictiveBack,
                          onChanged: cubit.setEnableAndroidPredictiveBack,
                          subtitle: "Android 14+",
                          title: "Predictive Back",
                          leading: const Icon(FluentIcons.tabs_24_filled),
                          isLast: true,
                        ),

                      const GroupTitle(title: "Player"),

                      SettingSwitchTile(
                        value: settings.enableNewPlayer,
                        onChanged: cubit.setEnableNewPlayer,
                        title: "Enable new player",
                        leading: const Icon(FluentIcons.slide_play_24_filled),
                        isFirst: true,
                        isLast: true,
                      ),

                      const BottomPlayingPadding(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleDarkThemeChange(BuildContext context) async {
    final cubit = sl<SettingsService>().appearance;

    final res = await AppDialogs.showOptionSelectionDialog(
      context,
      children: [
        AppDialogTileData(title: 'On', value: ThemeMode.dark),
        AppDialogTileData(title: 'Off', value: ThemeMode.light),
        AppDialogTileData(title: 'Follow system', value: ThemeMode.system),
      ],
    );

    if (res != null) cubit.setDarkTheme(res);
  }

  Future<void> _handleAccentColorChange(BuildContext context) async {
    final cubit = sl<SettingsService>().appearance;

    final color = await AppDialogs.showColorSelectionDialog(context);
    if (color != null) {
      cubit.setAccentColor(color);
    }
  }

  Future<void> _handleLanguageChange(BuildContext context) async {
    final cubit = sl<SettingsService>().appearance;

    final language = await AppDialogs.showOptionSelectionDialog<AppLanguage>(
      context,
      children: _appLanguage,
    );

    if (language != null) cubit.setAppLanguage(language);
  }
}

final List<AppDialogTileData<AppLanguage>> _appLanguage = [
  AppDialogTileData(
    title: "English",
    value: AppLanguage(title: 'English', value: "en"),
  ),
  AppDialogTileData(
    title: "Hindi",
    value: AppLanguage(title: 'Hindi', value: "hi"),
  ),
  AppDialogTileData(
    title: "Urdu",
    value: AppLanguage(title: 'Urdu', value: "ur"),
  ),
];
