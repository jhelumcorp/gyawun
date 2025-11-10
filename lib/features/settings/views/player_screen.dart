import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

import '../widgets/setting_tile.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerSettings = sl<AppSettings>().playerSettings;
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: playerSettings.stream,
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
                    if (Platform.isAndroid) const GroupTitle(title: "General"),
                    if (Platform.isAndroid)
                      SettingSwitchTile(
                        title: "Skip silence",
                        leading: const Icon(FluentIcons.fast_forward_24_filled),
                        isFirst: true,
                        isLast: true,
                        value: settings.skipSilence,
                        onChanged: (value) async {
                          await sl<MediaPlayer>().setSkipSilenceEnabled(value);
                          await playerSettings.setSkipSilence(value);
                        },
                      ),
                    const GroupTitle(title: "Mini Player"),
                    SettingSwitchTile(
                      title: "Enable next button",
                      leading: const Icon(FluentIcons.next_24_filled),
                      isFirst: true,
                      value: settings.miniPlayerNextButton,
                      onChanged: (value) async {
                        await playerSettings.setMiniPlayerNextButton(value);
                      },
                    ),
                    SettingSwitchTile(
                      title: "Enable previous button",
                      leading: const Icon(FluentIcons.previous_24_filled),
                      isLast: true,
                      value: settings.miniPlayerPreviousButton,
                      onChanged: (value) async {
                        await playerSettings.setMiniPlayerPreviousButton(value);
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
