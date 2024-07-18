import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../services/bottom_message.dart';
import '../../../services/file_storage.dart';
import '../../../services/library.dart';
import '../../../services/settings_manager.dart';
import '../../../utils/bottom_modals.dart';
import '../setting_item.dart';

List<SettingItem> backupRestoreScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).Backup,
        icon: Icons.backup_outlined,
        onTap: (context) => _backup(context),
      ),
      SettingItem(
        title: S.of(context).Restore,
        icon: Icons.restore_outlined,
        onTap: (context) => GetIt.I<FileStorage>().loadBackup(context),
      )
    ];

_backup(BuildContext context) async {
  List? items = await showCupertinoModalPopup(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        ValueNotifier<List<Map<String, dynamic>>> items = ValueNotifier([
          {'name': 'Favourites', 'selected': false},
          {'name': 'Playlists', 'selected': false},
          {'name': 'Settings', 'selected': false},
          {'name': 'Song History', 'selected': false},
          {'name': 'Downloads', 'selected': false}
        ]);
        return BottomModalLayout(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text(S.of(context).Select_Backup),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),
                const Divider(),
                ValueListenableBuilder(
                  valueListenable: items,
                  builder: (context, backups, child) {
                    return Column(
                        children: backups.indexed.map((el) {
                      int index = el.$1;
                      Map<String, dynamic> element = el.$2;
                      return CheckboxListTile(
                        title: Text(element['name']),
                        value: element['selected'],
                        onChanged: (val) {
                          List<Map<String, dynamic>> newItems =
                              List.from(items.value);
                          newItems[index]['selected'] = val;
                          items.value = newItems;
                        },
                      );
                    }).toList());
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          List finalItems = items.value
                              .where((el) => el['selected'] == true)
                              .map((el) => el['name'].toLowerCase())
                              .toList();
                          context.pop(finalItems.isEmpty ? null : finalItems);
                        },
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Done',
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
  if (items == null) {
    return;
  }
  Map backup = {
    'name': 'Gyawun',
    'type': 'backup',
    'version': 1,
    'data': {},
  };
  if (items.contains('playlists')) {
    Map playlists = GetIt.I<LibraryService>().playlists;
    backup['data']['playlists'] = playlists;
  }
  if (items.contains('settings')) {
    Map settings = GetIt.I<SettingsManager>().settings;
    settings.remove('YTMUSIC_AUTH');
    backup['data']['settings'] = settings;
  }
  if (items.contains('favourites')) {
    Map favourites = Hive.box('FAVOURITES').toMap();
    backup['data']['favourites'] = favourites;
  }
  if (items.contains('song history')) {
    Map history = Hive.box('SONG_HISTORY').toMap();
    backup['data']['song_history'] = history;
  }
  if (items.contains('downloads')) {
    Map downloads = Hive.box('DOWNLOADS').toMap();
    backup['data']['downloads'] = downloads;
  }
  File? file = await GetIt.I<FileStorage>().saveBackUp(backup);
  if (file == null) return;
  if (context.mounted) {
    BottomMessage.showText(context, 'Backed up successfully at ${file.path}');
  }
}
