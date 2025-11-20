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
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/services/settings/cubits/appearance_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/app_appearance_state.dart';

import '../../../services/settings/models/app_language.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().appearance;

    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.appearance)),
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
                      GroupTitle(title: loc.theme, paddingTop: 0),

                      // Dark Theme
                      SettingTile(
                        title: loc.darkTheme,
                        leading: const Icon(FluentIcons.dark_theme_24_filled),
                        subtitle: settings.themeMode.name,
                        isFirst: true,
                        onTap: () => _handleDarkThemeChange(context),
                      ),

                      // Accent Color
                      SettingTile(
                        onTap: () => _handleAccentColorChange(context),
                        title: loc.accentColor,
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
                        title: loc.enableDynamicTheme,
                        leading: const Icon(FluentIcons.color_background_24_filled),
                      ),

                      // Pure Black
                      SettingSwitchTile(
                        title: loc.pureBlack,
                        leading: const Icon(FluentIcons.drop_24_filled),
                        value: settings.isPureBlack,
                        onChanged: cubit.setIsPureBlack,
                      ),

                      // System colors
                      SettingSwitchTile(
                        value: settings.enableSystemColors,
                        onChanged: cubit.setEnableSystemColors,
                        title: loc.enableSystemColors,
                        leading: const Icon(FluentIcons.system_24_filled),
                        isLast: true,
                      ),

                      GroupTitle(title: loc.layout),

                      // Language
                      SettingTile(
                        title: loc.language,
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
                          subtitle: loc.android14Plus,
                          title: loc.predictiveBack,
                          leading: const Icon(FluentIcons.tabs_24_filled),
                          isLast: true,
                        ),

                      GroupTitle(title: loc.player),

                      SettingSwitchTile(
                        value: settings.enableNewPlayer,
                        onChanged: cubit.setEnableNewPlayer,
                        title: loc.enableNewPlayer,
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
        AppDialogTileData(title: AppLocalizations.of(context)!.on, value: ThemeMode.dark),
        AppDialogTileData(title: AppLocalizations.of(context)!.off, value: ThemeMode.light),
        AppDialogTileData(
          title: AppLocalizations.of(context)!.followSystem,
          value: ThemeMode.system,
        ),
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
