import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/cubits/player_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/player_settings_state.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().player;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.player)),
      body: BlocBuilder<PlayerSettingsCubit, PlayerSettingsState>(
        bloc: cubit,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                minimum: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    if (Platform.isAndroid) GroupTitle(title: loc.general, paddingTop: 0),
                    if (Platform.isAndroid)
                      SettingSwitchTile(
                        title: loc.skipSilence,
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

                    GroupTitle(title: loc.miniPlayer, paddingTop: Platform.isAndroid ? null : 0),

                    SettingSwitchTile(
                      title: loc.enableNextButton,
                      leading: const Icon(FluentIcons.next_24_filled),
                      isFirst: true,
                      value: state.miniPlayerNextButton,
                      onChanged: cubit.setMiniPlayerNextButton,
                    ),

                    SettingSwitchTile(
                      title: loc.enablePreviousButton,
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
