import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
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
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                StreamBuilder<bool?>(
                  stream: playerSettings.skipSilenceStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return SettingSwitchTile(
                      title: "Skip silence",
                      leading: const Icon(FluentIcons.fast_forward_24_filled),
                      isFirst: true,
                      isLast: true,
                      value: snapshot.data ?? false,
                      onChanged: (value) async {
                        await sl<MediaPlayer>().setSkipSilenceEnabled(value);
                        await playerSettings.setSkipSilence(value);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
