import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/settings/saavn_settings.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class JioSaavnScreen extends StatelessWidget {
  const JioSaavnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jsSettings = sl<AppSettings>().jioSaavnSettings;

    return Scaffold(
      appBar: AppBar(title: const Text("Jio Saavn")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<JioSaavnConfig>(
          stream: jsSettings.stream,
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

                    const GroupTitle(title: "Audio quality"),
                    SettingTile(
                      title: "Streaming quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      isFirst: true,
                      subtitle: "${settings.streamingQuality.bitrate} Kbps",
                      onTap: () async {
                        final quality = await AppDialogs.showOptionSelectionDialog(
                          context,
                          title: "Audio Quality",
                          children: JSAudioQuality.values
                              .map(
                                (quality) => AppDialogTileData(
                                  title: "${quality.bitrate} Kbps",
                                  value: quality,
                                ),
                              )
                              .toList(),
                        );
                        if (quality != null) {
                          await jsSettings.setAudioStreamingQuality(quality);
                        }
                      },
                    ),
                    SettingTile(
                      title: "Downloading quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      subtitle: "${settings.downloadingQuality.bitrate} Kbps",
                      isLast: true,
                      onTap: () async {
                        final quality = await AppDialogs.showOptionSelectionDialog(
                          context,
                          title: "Audio Quality",
                          children: JSAudioQuality.values
                              .map(
                                (quality) => AppDialogTileData(
                                  title: "${quality.bitrate} Kbps",
                                  value: quality,
                                ),
                              )
                              .toList(),
                        );
                        if (quality != null) {
                          await jsSettings.setAudioDownloadingQuality(quality);
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
