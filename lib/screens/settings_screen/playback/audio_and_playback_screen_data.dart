import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/services/media_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../services/bottom_message.dart';
import '../../../services/settings_manager.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/bottom_modals.dart';
import '../setting_item.dart';

Box _box = Hive.box('SETTINGS');

List<SettingItem> audioandplaybackScreenData(BuildContext context) => [
      if (Platform.isAndroid)
        SettingItem(
          title: S.of(context).LoudnessAndEqualizer,
          icon: Icons.equalizer_outlined,
          location: '/settings/playback/equalizer',
          hasNavigation: true,
        ),
      SettingItem(
        title: "Audio Quality",
        icon: CupertinoIcons.speaker_zzz,
        trailing: (context) => DropdownButton(
            style: textStyle(context, bold: false).copyWith(fontSize: 16),
            underline: const SizedBox(),
            value: context.watch<SettingsManager>().audioQuality,
            items: context
                .read<SettingsManager>()
                .audioQualities
                .map(
                  (e) => DropdownMenuItem(
                      value: e, child: Text(e.name.toUpperCase())),
                )
                .toList(),
            onChanged: (value) async {
              if (value == null) return;
              context.read<SettingsManager>().audioQuality = value;
            }),
      ),
      SettingItem(
        title: "Download Quality",
        icon: CupertinoIcons.speaker_zzz,
        trailing: (context) => DropdownButton(
            style: textStyle(context, bold: false).copyWith(fontSize: 16),
            underline: const SizedBox(),
            value: context.watch<SettingsManager>().downloadQuality,
            items: context
                .read<SettingsManager>()
                .audioQualities
                .map(
                  (e) => DropdownMenuItem(
                      value: e, child: Text(e.name.toUpperCase())),
                )
                .toList(),
            onChanged: (value) async {
              if (value == null) return;
              context.read<SettingsManager>().downloadQuality = value;
            }),
      ),
      SettingItem(
        title: 'Skip Silence',
        icon: CupertinoIcons.forward_end_alt,
        onTap: (context) async {
          await GetIt.I<MediaPlayer>()
              .skipSilence(!(context.read<SettingsManager>().skipSilence));
        },
        trailing: (context) {
          return CupertinoSwitch(
              value: context.watch<SettingsManager>().skipSilence,
              onChanged: (value) async {
                await GetIt.I<MediaPlayer>().skipSilence(value);
              });
        },
      ),
      SettingItem(
        title: S.of(context).enablePlaybackHistory,
        icon: Icons.manage_history_sharp,
        onTap: (context) async {
          bool isEnabled = _box.get('PLAYBACK_HISTORY', defaultValue: true);
          await _box.put('PLAYBACK_HISTORY', !isEnabled);
        },
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: _box.listenable(keys: ['PLAYBACK_HISTORY']),
            builder: (context, value, child) {
              bool isEnabled =
                  value.get('PLAYBACK_HISTORY', defaultValue: true);
              return CupertinoSwitch(
                  value: isEnabled,
                  onChanged: (val) async {
                    await value.put('PLAYBACK_HISTORY', val);
                  });
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).deletePlaybackHistory,
        icon: Icons.playlist_remove,
        onTap: (context) async {
          bool? confirm = await Modals.showConfirmBottomModal(
            context,
            message: S.of(context).deletePlaybackHistoryDialogText,
            isDanger: true,
          );
          if (confirm == true) {
            await Hive.box('SONG_HISTORY').clear();
            if (context.mounted) {
              BottomMessage.showText(context, 'Playback History deleted');
            }
          }
        },
      ),
      SettingItem(
        title: S.of(context).enableSearchHistory,
        icon: Icons.search_off_sharp,
        onTap: (context) async {
          bool isEnabled = _box.get('SEARCH_HISTORY', defaultValue: true);
          await _box.put('SEARCH_HISTORY', !isEnabled);
        },
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: _box.listenable(keys: ['SEARCH_HISTORY']),
            builder: (context, value, child) {
              bool isEnabled = value.get('SEARCH_HISTORY', defaultValue: true);
              return CupertinoSwitch(
                  value: isEnabled,
                  onChanged: (val) async {
                    await value.put('SEARCH_HISTORY', val);
                  });
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).deleteSearchHistory,
        icon: Icons.highlight_remove_sharp,
        onTap: (context) async {
          bool? confirm = await Modals.showConfirmBottomModal(
            context,
            message: S.of(context).deleteSearchHistoryDialogText,
            isDanger: true,
          );
          if (confirm == true) {
            await Hive.box('SEARCH_HISTORY').clear();
            if (context.mounted) {
              BottomMessage.showText(context, 'Search History deleted');
            }
          }
        },
      ),
    ];

List<AudioQualities> qualities = [AudioQualities.high, AudioQualities.low];

enum AudioQualities { high, low }
