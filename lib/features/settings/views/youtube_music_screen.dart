import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/settings/youtube_settings.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';

import '../widgets/group_title.dart';
import '../widgets/setting_tile.dart';

class YoutubeMusicScreen extends StatelessWidget {
  const YoutubeMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ytSettings = sl<AppSettings>().youtubeMusicSettings;

    return Scaffold(
      appBar: AppBar(title: const Text("Youtube Music")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<YtMusicConfig>(
          stream: ytSettings.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    const SizedBox(height: 8),
                    const GroupTitle(title: "General"),
                    SettingTile(
                      title: "Audio quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      isFirst: true,
                      subtitle: settings.audioQuality.name.toUpperCase(),
                      onTap: () async {
                        final quality = await AppDialogs.showOptionSelectionDialog(
                          context,
                          title: "Audio Quality",
                          children: [
                            AppDialogTileData(title: "HIGH", value: AudioQuality.high),
                            AppDialogTileData(title: "LOW", value: AudioQuality.low),
                          ],
                        );
                        if (quality != null) {
                          await ytSettings.setAudioQuality(quality);
                        }
                      },
                    ),
                    SettingTile(
                      title: "Language",
                      leading: const Icon(FluentIcons.local_language_24_filled),
                      subtitle: settings.language.title,
                      onTap: () async {
                        final language =
                            await AppDialogs.showOptionSelectionDialog<YtMusicLanguage>(
                              context,
                              children: _languages,
                            );
                        if (language != null) {
                          await ytSettings.setLanguage(language);
                        }
                      },
                    ),
                    SettingTile(
                      title: "Location",
                      leading: const Icon(FluentIcons.location_24_filled),
                      isLast: true,
                      subtitle: settings.location.title,
                      onTap: () async {
                        final location =
                            await AppDialogs.showOptionSelectionDialog<YtMusicLocation>(
                              context,
                              children: _locations,
                            );
                        if (location != null) {
                          await ytSettings.setLocation(location);
                        }
                      },
                    ),
                    const GroupTitle(title: "Privacy"),
                    SettingSwitchTile(
                      title: "Personalised Content",
                      leading: const Icon(Icons.recommend),
                      value: settings.personalisedContent,
                      isFirst: true,
                      onChanged: (value) async {
                        await ytSettings.setPersonalisedContent(value);
                      },
                    ),
                    SettingTile(
                      title: "Enter visitor ID",
                      leading: const Icon(FluentIcons.edit_24_filled),
                      subtitle: settings.visitorId,
                      trailing: IconButton.filled(
                        isSelected: false,
                        onPressed: () async {
                          if (settings.visitorId == null) return;
                          await Clipboard.setData(ClipboardData(text: settings.visitorId!));
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text("Copied to clipboard!")));
                          }
                        },
                        icon: const Icon(FluentIcons.copy_24_filled),
                      ),
                      onTap: () async {
                        final id = await AppDialogs.showPromptDialog(
                          context,
                          title: "Enter Visitor Id",
                        );
                        if (id != null) {
                          await ytSettings.setVisitorId(id);
                        }
                      },
                    ),
                    SettingTile(
                      title: "Reset Visitor ID",
                      leading: const Icon(FluentIcons.key_reset_24_filled),
                      isLast: true,
                      onTap: () async {
                        // Add confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Reset Visitor ID"),
                            content: const Text("Are you sure you want to reset your visitor ID?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Reset"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ytSettings.setVisitorId(null);
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text("Visitor ID reset!")));
                          }
                        }
                      },
                    ),
                    const BottomPlayingPadding(),
                  ],
                ),
              ],
            );
          },
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
