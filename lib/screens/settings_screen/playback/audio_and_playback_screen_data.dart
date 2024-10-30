import 'dart:io';

import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/services/file_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../services/bottom_message.dart';
import '../../../services/media_player.dart';
import '../../../services/settings_manager.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../../utils/bottom_modals.dart';
import '../setting_item.dart';

Box _box = Hive.box('SETTINGS');

List<SettingItem> audioandplaybackScreenData(BuildContext context) => [
      if (!Platform.isWindows)
        SettingItem(
          title: S.of(context).Loudness_And_Equalizer,
          icon: Icons.equalizer_outlined,
          location: '/settings/playback/equalizer',
          hasNavigation: true,
        ),
      SettingItem(
        title: S.of(context).Streaming_Quality,
        icon: CupertinoIcons.speaker_zzz,
        hasNavigation: false,
        trailing: (context) {
          return AdaptiveDropdownButton(
            value: context.watch<SettingsManager>().streamingQuality,
            items: context
                .read<SettingsManager>()
                .audioQualities
                .map(
                  (e) => AdaptiveDropdownMenuItem(
                    value: e,
                    child: Text(
                      textAlign: TextAlign.right,
                      e.name.toUpperCase(),
                      style: smallTextStyle(context),
                      maxLines: 2,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              context.read<SettingsManager>().streamingQuality = value;
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).DOwnload_Quality,
        icon: CupertinoIcons.speaker_zzz,
        trailing: (context) {
          return AdaptiveDropdownButton(
              value: context.watch<SettingsManager>().downloadQuality,
              items: context
                  .read<SettingsManager>()
                  .audioQualities
                  .map(
                    (e) => AdaptiveDropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name.toUpperCase(),
                        style: smallTextStyle(context, bold: false),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                context.read<SettingsManager>().downloadQuality = value;
              });
        },
      ),
     if(Platform.isAndroid) SettingItem(
        title: "App Folder",
        icon: CupertinoIcons.folder,
        subtitle: (context) {
          return ValueListenableBuilder(valueListenable: Hive.box('SETTINGS').listenable(keys:['APP_FOLDER']), builder:(context, value, child) {
            return Text(value.get('APP_FOLDER',defaultValue:'/storage/emulated/0/Download'),style:const TextStyle(fontSize: 10),);
          },);
        },
        trailing: (context) {
          return AdaptiveOutlinedButton(child:const Text('Change'), onPressed: ()async{
            Directory? newDirectory = await FolderPicker.pick(
              allowFolderCreation: true,
              context: context,
              rootDirectory: Directory(_box.get('APP_FOLDER', defaultValue: GetIt.I<FileStorage>().storagePaths.basePath)?? FolderPicker.rootPath),
              shape:const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              )
            );
            if(newDirectory!=null){
              await _box.put('APP_FOLDER', newDirectory.path);
              await GetIt.I<FileStorage>().updateDirectories();
            }
          });
        },
      ),
      if (!Platform.isWindows)
        SettingItem(
          title: S.of(context).Skip_Silence,
          icon: CupertinoIcons.forward_end_alt,
          onTap: (context) async {
            await GetIt.I<MediaPlayer>()
                .skipSilence(!(context.read<SettingsManager>().skipSilence));
          },
          trailing: (context) {
            return AdaptiveSwitch(
                value: context.watch<SettingsManager>().skipSilence,
                onChanged: (value) async {
                  await GetIt.I<MediaPlayer>().skipSilence(value);
                });
          },
        ),
      SettingItem(
        title: S.of(context).Enable_Playback_History,
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

              return AdaptiveSwitch(
                  value: isEnabled,
                  onChanged: (val) async {
                    await value.put('PLAYBACK_HISTORY', val);
                  });
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).Delete_Playback_History,
        icon: Icons.playlist_remove,
        onTap: (context) async {
          bool? confirm = await Modals.showConfirmBottomModal(
            context,
            message: S.of(context).Delete_Playback_History_Confirm_Message,
            isDanger: true,
          );
          if (confirm == true) {
            await Hive.box('SONG_HISTORY').clear();
            if (context.mounted) {
              BottomMessage.showText(
                  context, S.of(context).Playback_History_Deleted);
            }
          }
        },
      ),
      SettingItem(
        title: S.of(context).Enable_Search_History,
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

              return AdaptiveSwitch(
                  value: isEnabled,
                  onChanged: (val) async {
                    await value.put('SEARCH_HISTORY', val);
                  });
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).Delete_Search_History,
        icon: Icons.highlight_remove_sharp,
        onTap: (context) async {
          bool? confirm = await Modals.showConfirmBottomModal(
            context,
            message: S.of(context).Delete_Search_History_Confirm_Message,
            isDanger: true,
          );
          if (confirm == true) {
            await Hive.box('SEARCH_HISTORY').clear();
            if (context.mounted) {
              BottomMessage.showText(
                  context, S.of(context).Search_History_Deleted);
            }
          }
        },
      ),
    ];

List<AudioQualities> qualities = [AudioQualities.high, AudioQualities.low];

enum AudioQualities { high, low }
