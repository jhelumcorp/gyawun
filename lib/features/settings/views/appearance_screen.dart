import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = sl<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: Text("Appearance")),
      body: StreamBuilder(
        stream: appSettings.appearance(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            final settings = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GroupTitle(title: "Theme"),
                        SettingTile(
                          title: "Dark theme",
                          leading: Icon(FluentIcons.dark_theme_24_filled),
                          subtitle: settings.themeMode.text,
                          isFirst: true,
                          onTap: () async {
                            final res =
                                await AppDialogs.showOptionSelectionDialog(
                                  context,
                                  children: [
                                    AppDialogTileData(title: 'On', value: 'on'),
                                    AppDialogTileData(
                                      title: 'Off',
                                      value: 'off',
                                    ),
                                    AppDialogTileData(
                                      title: 'Follow system',
                                      value: 'system',
                                    ),
                                  ],
                                );
                            if (res != null) {
                              await appSettings.setString(
                                AppSettingsIdentifiers.darkTheme,
                                res,
                              );
                            }
                          },
                        ),
                        SettingTile(
                          onTap: () async {
                            final color =
                                await AppDialogs.showColorSelectionDialog(
                                  context,
                                );
                            if (color != null) {
                              await appSettings.setColor(
                                AppSettingsIdentifiers.accentColor,
                                color,
                              );
                            }
                          },
                          title: "Accent Color",
                          leading: Icon(FluentIcons.color_24_filled),
                          trailing: CircleAvatar(
                            radius: 20,
                            backgroundColor: settings.accentColor,
                          ),
                        ),
                        SettingSwitchTile(
                          title: "Pure black",
                          leading: Icon(FluentIcons.drop_24_filled),
                          value: settings.isPureBlack,
                          onChanged: (value) async {
                            await appSettings.setBool(
                              AppSettingsIdentifiers.isPureBlack,
                              value,
                            );
                          },
                        ),

                        SettingSwitchTile(
                          value: settings.enableSystemColors,
                          onChanged: (value) async {
                            await appSettings.setBool(
                              AppSettingsIdentifiers.enableSystemColors,
                              value,
                            );
                          },
                          title: "Enable system colors",
                          leading: Icon(FluentIcons.system_24_filled),
                          isLast: true,
                        ),

                        GroupTitle(title: "Layout"),
                        SettingTile(
                          title: "Language",
                          leading: Icon(FluentIcons.local_language_24_filled),
                          isFirst: true,
                          subtitle: settings.language.title,
                          onTap: () async {
                            final language =
                                await AppDialogs.showOptionSelectionDialog<
                                  AppLanguage
                                >(context, children: _appLanguage);
                            if (language != null) {
                              await appSettings.setString(
                                AppSettingsIdentifiers.appLanguage,
                                jsonEncode(language.toJson()),
                              );
                            }
                          },
                        ),
                        SettingSwitchTile(
                          value: settings.enableAndroidPredictiveBack,
                          onChanged: (value) async {
                            await appSettings.setBool(
                              AppSettingsIdentifiers
                                  .enableAndroidPredictiveBack,
                              value,
                            );
                          },
                          subtitle: "Android 14+",
                          title: "Predictive Back",
                          leading: Icon(FluentIcons.tabs_24_filled),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
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
