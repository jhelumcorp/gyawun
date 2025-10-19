import 'dart:io';

import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:gyawun/services/bottom_message.dart';
import 'package:gyawun/services/file_storage.dart';
import 'package:gyawun/services/library.dart';
import 'package:gyawun/services/settings_manager.dart';
import 'package:gyawun/utils/bottom_modals.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';

class BackupStorageScreen extends StatelessWidget {
  const BackupStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box('SETTINGS');
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Backup_And_Restore),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              if (Platform.isAndroid) ...[
                GroupTitle(title: "Storage"),
                ValueListenableBuilder(
                    valueListenable:
                        Hive.box('SETTINGS').listenable(keys: ['APP_FOLDER']),
                    builder: (context, item, child) {
                      return SettingTile(
                          title: "App Folder",
                          leading: Icon(CupertinoIcons.folder),
                          isFirst: true,
                          isLast: true,
                          subtitle: item.get('APP_FOLDER',
                              defaultValue: '/storage/emulated/0/Download'),
                          trailing: AdaptiveOutlinedButton(
                              child: const Text('Change'),
                              onPressed: () async {
                                Directory? newDirectory =
                                    await FolderPicker.pick(
                                        allowFolderCreation: true,
                                        context: context,
                                        rootDirectory: Directory(box.get(
                                                'APP_FOLDER',
                                                defaultValue:
                                                    GetIt.I<FileStorage>()
                                                        .storagePaths
                                                        .basePath) ??
                                            FolderPicker.rootPath),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))));
                                if (newDirectory != null) {
                                  await box.put(
                                      'APP_FOLDER', newDirectory.path);
                                  await GetIt.I<FileStorage>()
                                      .updateDirectories();
                                }
                              }));
                    })
              ],
              GroupTitle(title: S.of(context).Backup_And_Restore),
              SettingTile(
                title: S.of(context).Backup,
                leading: Icon(Icons.backup_outlined),
                isFirst: true,
                onTap: () => _backup(context),
              ),
              SettingTile(
                title: S.of(context).Restore,
                leading: Icon(Icons.restore_outlined),
                isLast: true,
                onTap: () async {
                  bool success =
                      await GetIt.I<FileStorage>().loadBackup(context);
                  if (context.mounted) {
                    if (success) {
                      BottomMessage.showText(
                          context, S.of(context).Restore_Success);
                    } else {
                      BottomMessage.showText(
                          context, S.of(context).Restore_Failed);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _backup(BuildContext context) async {
  String? action;
  List? items;
  (action, items) = await showCupertinoModalPopup(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          List finalItems = items.value
                              .where((el) => el['selected'] == true)
                              .map((el) => el['name'].toLowerCase())
                              .toList();
                          context.pop(finalItems.isEmpty
                              ? (null, null)
                              : ("Share", finalItems));
                        },
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          S.of(context).Share,
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          List finalItems = items.value
                              .where((el) => el['selected'] == true)
                              .map((el) => el['name'].toLowerCase())
                              .toList();
                          context.pop(finalItems.isEmpty
                              ? (null, null)
                              : ("Save", finalItems));
                        },
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          S.of(context).Save,
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
  if (action == null || items == null) {
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
  String? backupPath = "";
  if (action == 'Save') {
    backupPath = await GetIt.I<FileStorage>().saveBackUp(backup);
  } else if (action == 'Share') {
    backupPath = await GetIt.I<FileStorage>().shareBackUp(backup);
  }
  if (context.mounted) {
    if (backupPath == "") {
      BottomMessage.showText(context, S.of(context).Backup_Failed);
    } else {
      BottomMessage.showText(
          context, '${S.of(context).Backup_Success} $backupPath');
    }
  }
}
