import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/cubits/player_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/player_settings_state.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().player;

    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: BlocBuilder<PlayerSettingsCubit, PlayerSettingsState>(
        bloc: cubit,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                minimum: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    if (Platform.isAndroid) const GroupTitle(title: "General"),
                    if (Platform.isAndroid)
                      SettingSwitchTile(
                        title: "Skip silence",
                        leading: const Icon(FluentIcons.fast_forward_24_filled),
                        isFirst: true,
                        isLast: true,
                        value: state.skipSilence,
                        onChanged: (value) async {
                          // update player engine
                          await sl<MediaPlayer>().setSkipSilenceEnabled(value);

                          // persist setting
                          cubit.setSkipSilence(value);
                        },
                      ),

                    const GroupTitle(title: "Mini Player"),

                    SettingSwitchTile(
                      title: "Enable next button",
                      leading: const Icon(FluentIcons.next_24_filled),
                      isFirst: true,
                      value: state.miniPlayerNextButton,
                      onChanged: cubit.setMiniPlayerNextButton,
                    ),

                    SettingSwitchTile(
                      title: "Enable previous button",
                      leading: const Icon(FluentIcons.previous_24_filled),
                      isLast: true,
                      value: state.miniPlayerPreviousButton,
                      onChanged: cubit.setMiniPlayerPreviousButton,
                    ),

                    const BottomPlayingPadding(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
