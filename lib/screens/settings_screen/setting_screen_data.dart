import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/bottom_modals.dart';
import '../../utils/check_update.dart';
import 'appearence/appearence_screen_data.dart';
import 'content/content_screen_data.dart';
import 'playback/audio_and_playback_screen_data.dart';
import 'setting_item.dart';

List<SettingItem> settingScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).appearence,
        icon: Icons.looks,
        color: Colors.accents[0],
        hasNavigation: true,
        location: '/settings/appearence',
      ),
      SettingItem(
        title: 'Content',
        icon: CupertinoIcons.music_note_list,
        color: Colors.accents[1],
        hasNavigation: true,
        location: '/settings/content',
      ),
      SettingItem(
        title: S.of(context).audioAndPlayback,
        icon: CupertinoIcons.music_note,
        color: Colors.accents[2],
        hasNavigation: true,
        location: '/settings/playback',
      ),
      SettingItem(
        title: 'Back up and Restore',
        icon: Icons.settings_backup_restore_outlined,
        color: Colors.accents[3],
        hasNavigation: true,
        location: '/settings/backup_restore',
      ),
      SettingItem(
        title: S.of(context).about,
        icon: Icons.info_rounded,
        color: Colors.accents[4],
        hasNavigation: true,
        location: '/settings/about',
      ),
      SettingItem(
        title: 'Check for Update',
        icon: Icons.update_outlined,
        color: Colors.accents[5],
        onTap: (context) async {
          Modals.showCenterLoadingModal(context);
          checkUpdate().then((updateInfo) {
            Navigator.pop(context);
            Modals.showUpdateDialog(context, updateInfo);
          });
        },
      ),
    ];
List<SettingItem> allSettingsData(BuildContext context) => [
      ...settingScreenData(context),
      ...appearenceScreenData(context),
      ...contentScreenData(context),
      ...audioandplaybackScreenData(context)
    ];
