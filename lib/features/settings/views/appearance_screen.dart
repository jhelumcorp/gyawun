import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appearanceSettings = sl<AppSettings>().appearanceSettings;

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<AppAppearance>(
          stream: appearanceSettings.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = snapshot.data!;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GroupTitle(title: "Theme"),
                      SettingTile(
                        title: "Dark theme",
                        leading: const Icon(FluentIcons.dark_theme_24_filled),
                        subtitle: settings.themeMode.text,
                        isFirst: true,
                        onTap: () => _handleDarkThemeChange(context, appearanceSettings),
                      ),
                      SettingTile(
                        onTap: () => _handleAccentColorChange(context, appearanceSettings),
                        title: "Accent Color",
                        leading: const Icon(FluentIcons.color_24_filled),
                        trailing: CircleAvatar(radius: 20, backgroundColor: settings.accentColor),
                      ),
                      SettingSwitchTile(
                        value: settings.enableDynamicTheme,
                        onChanged: appearanceSettings.setEnableDynamicTheme,
                        title: "Enable dynamic theme",
                        leading: const Icon(FluentIcons.color_background_24_filled),
                      ),
                      SettingSwitchTile(
                        title: "Pure black",
                        leading: const Icon(FluentIcons.drop_24_filled),
                        value: settings.isPureBlack,
                        onChanged: appearanceSettings.setIsPureBlack,
                      ),
                      SettingSwitchTile(
                        value: settings.enableSystemColors,
                        onChanged: appearanceSettings.setEnableSystemColors,
                        title: "Enable system colors",
                        leading: const Icon(FluentIcons.system_24_filled),
                        isLast: true,
                      ),
                      const GroupTitle(title: "Layout"),
                      SettingTile(
                        title: "Language",
                        leading: const Icon(FluentIcons.local_language_24_filled),
                        isFirst: true,
                        subtitle: settings.language.title,
                        onTap: () => _handleLanguageChange(context, appearanceSettings),
                      ),
                      SettingSwitchTile(
                        value: settings.enableAndroidPredictiveBack,
                        onChanged: appearanceSettings.setEnableAndroidPredictiveBack,
                        subtitle: "Android 14+",
                        title: "Predictive Back",
                        leading: const Icon(FluentIcons.tabs_24_filled),
                        isLast: true,
                      ),
                      const GroupTitle(title: "Player"),
                      SettingSwitchTile(
                        value: settings.enableNewPlayer,
                        onChanged: appearanceSettings.setEnableNewPlayer,
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleDarkThemeChange(BuildContext context, AppearanceSettings settings) async {
    final res = await AppDialogs.showOptionSelectionDialog(
      context,
      children: [
        AppDialogTileData(title: 'On', value: 'on'),
        AppDialogTileData(title: 'Off', value: 'off'),
        AppDialogTileData(title: 'Follow system', value: 'system'),
      ],
    );
    if (res != null) {
      await settings.setDarkTheme(res);
    }
  }

  Future<void> _handleAccentColorChange(BuildContext context, AppearanceSettings settings) async {
    final color = await AppDialogs.showColorSelectionDialog(context);
    if (color != null) {
      await settings.setAccentColor(color);
    }
  }

  Future<void> _handleLanguageChange(BuildContext context, AppearanceSettings settings) async {
    final language = await AppDialogs.showOptionSelectionDialog<AppLanguage>(
      context,
      children: _appLanguage,
    );
    if (language != null) {
      await settings.setAppLanguage(language);
    }
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
