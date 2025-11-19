import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialogs.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/settings/cubits/yt_music_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/yt_music_state.dart';
import 'package:ytmusic/yt_music_base.dart';

import '../../../services/settings/enums/yt_audio_quality.dart';
import '../../../services/settings/models/yt_music_language.dart';
import '../../../services/settings/models/yt_music_location.dart';

class YoutubeMusicScreen extends StatelessWidget {
  const YoutubeMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<SettingsService>().youtubeMusic;

    return Scaffold(
      appBar: AppBar(title: const Text("Youtube Music")),
      body: BlocBuilder<YtMusicCubit, YtMusicState>(
        bloc: cubit,
        builder: (context, settings) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                minimum: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    // GENERAL
                    const GroupTitle(title: "General", paddingTop: 0),
                    SettingTile(
                      title: "Language",
                      leading: const Icon(FluentIcons.local_language_24_filled),
                      subtitle: settings.language.title,
                      isFirst: true,
                      onTap: () async {
                        final lang = await AppDialogs.showOptionSelectionDialog<YtMusicLanguage>(
                          context,
                          children: _languages,
                        );
                        if (lang != null) {
                          cubit.setLanguage(lang);
                          sl<YTMusic>().setLanguage(lang.value);
                        }
                      },
                    ),

                    SettingTile(
                      title: "Location",
                      leading: const Icon(FluentIcons.location_24_filled),
                      subtitle: settings.location.title,
                      isLast: true,
                      onTap: () async {
                        final loc = await AppDialogs.showOptionSelectionDialog<YtMusicLocation>(
                          context,
                          children: _locations,
                        );
                        if (loc != null) {
                          cubit.setLocation(loc);
                          sl<YTMusic>().setLocation(loc.value);
                        }
                      },
                    ),

                    // AUDIO QUALITY
                    const GroupTitle(title: "Audio quality"),

                    SettingTile(
                      title: "Streaming quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      isFirst: true,
                      subtitle: settings.streamingQuality.name.toUpperCase(),
                      onTap: () async {
                        final q = await AppDialogs.showOptionSelectionDialog(
                          context,
                          title: "Audio Quality",
                          children: [
                            AppDialogTileData(title: "HIGH", value: YTAudioQuality.high),
                            AppDialogTileData(title: "LOW", value: YTAudioQuality.low),
                          ],
                        );
                        if (q != null) cubit.setAudioStreamingQuality(q);
                      },
                    ),

                    SettingTile(
                      title: "Downloading quality",
                      leading: const Icon(Icons.spatial_audio_rounded),
                      subtitle: settings.downloadingQuality.name.toUpperCase(),
                      isLast: true,
                      onTap: () async {
                        final q = await AppDialogs.showOptionSelectionDialog(
                          context,
                          title: "Audio Quality",
                          children: [
                            AppDialogTileData(title: "HIGH", value: YTAudioQuality.high),
                            AppDialogTileData(title: "LOW", value: YTAudioQuality.low),
                          ],
                        );
                        if (q != null) cubit.setAudioDownloadingQuality(q);
                      },
                    ),

                    // SPONSOR BLOCK
                    const GroupTitle(title: "Sponsor Block"),

                    SettingExpansionTile(
                      title: "Enable Sponsor Block",
                      leading: const Icon(FluentIcons.presence_blocked_24_regular),
                      value: settings.sponsorBlock,
                      isFirst: true,
                      isLast: true,
                      onChanged: (v) => cubit.setSponsorBlock(v),
                      children: [
                        _sb(
                          context,
                          title: "Block Sponsors",
                          value: settings.sponsorBlockSponsor,
                          onChanged: cubit.setSponsorBlockSponsor,
                        ),
                        _sb(
                          context,
                          title: "Block Self Promo",
                          value: settings.sponsorBlockSelfpromo,
                          onChanged: cubit.setSponsorBlockSelfPromo,
                        ),
                        _sb(
                          context,
                          title: "Block Interaction",
                          value: settings.sponsorBlockInteraction,
                          onChanged: cubit.setSponsorBlockInteraction,
                        ),
                        _sb(
                          context,
                          title: "Block Intro",
                          value: settings.sponsorBlockIntro,
                          onChanged: cubit.setSponsorBlockIntro,
                        ),
                        _sb(
                          context,
                          title: "Block Outro",
                          value: settings.sponsorBlockOutro,
                          onChanged: cubit.setSponsorBlockOutro,
                        ),
                        _sb(
                          context,
                          title: "Block Preview",
                          value: settings.sponsorBlockPreview,
                          onChanged: cubit.setSponsorBlockPreview,
                        ),
                        _sb(
                          context,
                          title: "Block Music Offtopic",
                          isLast: true,
                          value: settings.sponsorBlockMusicOffTopic,
                          onChanged: cubit.setSponsorBlockMusicOffTopic,
                        ),
                      ],
                    ),

                    // PRIVACY
                    const GroupTitle(title: "Privacy"),

                    SettingSwitchTile(
                      title: "Personalised Content",
                      leading: const Icon(Icons.recommend),
                      value: settings.personalisedContent,
                      isFirst: true,
                      onChanged: cubit.setPersonalisedContent,
                    ),

                    SettingTile(
                      title: "Enter visitor ID",
                      leading: const Icon(FluentIcons.edit_24_filled),
                      subtitle: settings.visitorId,
                      trailing: IconButton.filled(
                        onPressed: settings.visitorId == null
                            ? null
                            : () async {
                                await Clipboard.setData(ClipboardData(text: settings.visitorId!));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text("Copied!")));
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
                          cubit.setVisitorId(id);
                          sl<YTMusic>().setVisitorId(id);
                        }
                      },
                    ),

                    SettingTile(
                      title: "Reset Visitor ID",
                      leading: const Icon(FluentIcons.key_reset_24_filled),
                      isLast: true,
                      onTap: () async {
                        final c = await YTMusic.fetchConfig();
                        if (c != null) {
                          cubit.setVisitorId(c.visitorData);
                          sl<YTMusic>().setConfig(c);
                        }
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

  Widget _sb(
    BuildContext context, {
    required String title,
    required bool value,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    final enabled = sl<SettingsService>().youtubeMusic.state.sponsorBlock;

    return SettingSwitchTile(
      title: title,
      dense: true,
      disabled: !enabled,
      value: value,
      isLast: isLast,
      onChanged: (v) => onChanged(v),
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
