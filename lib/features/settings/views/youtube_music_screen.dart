import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/providers/database_provider.dart';
import 'package:gyawun_music/database/settings/yt_music_settings.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class YoutubeMusicScreen extends ConsumerWidget {
  const YoutubeMusicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.read(appSettingsProvider);
    final ytMusicSettings = ref.watch(ytMusicSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Youtube Music")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ytMusicSettings.when(
          data: (settings) {
            return CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    SizedBox(height: 8),
                    GroupTitle(title: "General"),
                    SettingTile(
                      title: "Audio quality",
                      leading: Icon(Icons.spatial_audio_rounded),
                      isFirst: true,
                      subtitle: settings.audioQuality.name.toUpperCase(),
                      onTap: () async {
                        final quality =
                            await AppDialogs.showOptionSelectionDialog(
                              context,
                              title: "Audio Quality",
                              children: [
                                AppDialogTileData(
                                  title: "HIGH",
                                  value: AudioQuality.high,
                                ),
                                AppDialogTileData(
                                  title: "LOW",
                                  value: AudioQuality.low,
                                ),
                              ],
                            );
                        if (quality != null) {
                          await appSettings.setString(
                            AppSettingsIdentifiers.ytAudioQuality,
                            quality.name.toLowerCase(),
                          );
                        }
                      },
                    ),

                    SettingTile(
                      title: "Language",
                      leading: Icon(Icons.language),
                      subtitle: settings.language.title,
                      onTap: () async {
                        final language =
                            await AppDialogs.showOptionSelectionDialog<
                              YtMusicLanguage
                            >(context, children: _languages);
                        if (language != null) {
                          await appSettings.setString(
                            AppSettingsIdentifiers.ytLanguage,
                            jsonEncode(language.toJson()),
                          );
                        }
                      },
                    ),
                    SettingTile(
                      title: "Location",
                      leading: Icon(Icons.location_pin),
                      isLast: true,
                      subtitle: settings.location.title,
                      onTap: () async {
                        final language =
                            await AppDialogs.showOptionSelectionDialog<
                              YtMusicLocation
                            >(context, children: _locations);
                        if (language != null) {
                          await appSettings.setString(
                            AppSettingsIdentifiers.ytLocation,
                            jsonEncode(language.toJson()),
                          );
                        }
                      },
                    ),
                    GroupTitle(title: "Privacy"),

                    SettingSwitchTile(
                      title: "Personalised Content",
                      leading: Icon(Icons.recommend),
                      value: settings.personalisedContent,
                      isFirst: true,
                      onChanged: (value) async {
                        await appSettings.setBool(
                          AppSettingsIdentifiers.ytPersonalisedContent,
                          value,
                        );
                      },
                    ),

                    SettingTile(
                      title: "Enter Visitor ID",
                      isLast: true,
                      leading: Icon(Icons.edit),
                      subtitle: settings.visitorId,
                      trailing: IconButton.filled(
                        isSelected: false,
                        onPressed: () {},
                        icon: Icon(Icons.restart_alt),
                      ),
                      onTap: () async {
                        final id = await AppDialogs.showPromptDialog(
                          context,
                          title: "Enter Visitor Id",
                        );
                        if (id != null) {
                          await appSettings.setString(
                            AppSettingsIdentifiers.ytVisitorId,
                            id,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
          error: (_, _) => SizedBox.shrink(),
          loading: SizedBox.shrink,
        ),
      ),
    );
  }
}

final List<AppDialogTileData<YtMusicLanguage>> _languages = [
  AppDialogTileData(
    title: "English",
    value: YtMusicLanguage(title: 'English', value: "en"),
  ),
  AppDialogTileData(
    title: "Urdu",
    value: YtMusicLanguage(title: 'Urdu', value: "ur"),
  ),
];
final List<AppDialogTileData<YtMusicLocation>> _locations = [
  AppDialogTileData(
    title: "India",
    value: YtMusicLocation(title: 'India', value: "IN"),
  ),
  AppDialogTileData(
    title: "China",
    value: YtMusicLocation(title: 'China', value: "CN"),
  ),
  AppDialogTileData(
    title: "Pakistan",
    value: YtMusicLocation(title: 'Pakistan', value: "PK"),
  ),
];
