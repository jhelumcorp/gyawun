import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/settings/cubits/jiosaavn_settings_cubit.dart';
import 'package:gyawun_music/services/settings/enums/js_audio_quality.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/jio_saavn_state.dart';

class JioSaavnScreen extends StatelessWidget {
  const JioSaavnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().jioSaavn;

    return Scaffold(
      appBar: AppBar(title: const Text("JioSaavn")),
      body: BlocBuilder<JioSaavnCubit, JioSaavnState>(
        bloc: cubit,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                minimum: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    const GroupTitle(title: "Audio quality"),

                    // Streaming quality
                    SettingTile(
                      title: "Streaming quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      subtitle: "${state.streamingQuality.bitrate} Kbps",
                      isFirst: true,
                      onTap: () async {
                        final q = await AppDialogs.showOptionSelectionDialog<JSAudioQuality>(
                          context,
                          title: "Streaming Quality",
                          children: JSAudioQuality.values
                              .map(
                                (quality) => AppDialogTileData(
                                  title: "${quality.bitrate} Kbps",
                                  value: quality,
                                ),
                              )
                              .toList(),
                        );

                        if (q != null) cubit.setStreamingQuality(q);
                      },
                    ),

                    // Downloading quality
                    SettingTile(
                      title: "Downloading quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      subtitle: "${state.downloadingQuality.bitrate} Kbps",
                      isLast: true,
                      onTap: () async {
                        final q = await AppDialogs.showOptionSelectionDialog<JSAudioQuality>(
                          context,
                          title: "Downloading Quality",
                          children: JSAudioQuality.values
                              .map(
                                (quality) => AppDialogTileData(
                                  title: "${quality.bitrate} Kbps",
                                  value: quality,
                                ),
                              )
                              .toList(),
                        );

                        if (q != null) cubit.setDownloadingQuality(q);
                      },
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
