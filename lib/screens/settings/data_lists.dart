import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gyavun/api/extensions.dart';
import 'package:gyavun/models/setting_item.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/providers/theme_manager.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/format_duration.dart';
import 'package:gyavun/utils/snackbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

Box box = Hive.box('settings');

List<SettingItem> allDataLists = [
  ...[
    ...appLayoutSettingDataList,
    ...themesSettingDataList,
    ...playbackSettingDataList,
    ...downloadSettingDatalist,
    ...historySettingDatalist,
  ]..sort((a, b) => a.title.compareTo(b.title)),
  ...List.from(mainSettingDataList)..sort((a, b) => a.title.compareTo(b.title)),
];

List<SettingItem> mainSettingDataList = [
  SettingItem(
      title: 'Sleep timer',
      icon: Icons.timer,
      color: Colors.accents[0],
      onTap: (BuildContext context) {
        showDurationPicker(
                context: context,
                initialTime: const Duration(minutes: 30),
                snapToMins: 0.5,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)))
            .then((duration) {
          if (duration != null) {
            context.read<MediaManager>().setTimer(duration);
          }
        });
      },
      trailing: (context) {
        MediaManager mediaManager = context.watch<MediaManager>();
        return mediaManager.timerDuration != null
            ? Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Text(formatDuration(mediaManager.timerDuration!),
                      style: tinyTextStyle(context)),
                  IconButton(
                      onPressed: () {
                        mediaManager.cancelTimer();
                      },
                      icon: const Icon(EvaIcons.close))
                ],
              )
            : null;
      }),
  SettingItem(
    title: "App Layout",
    icon: EvaIcons.layout,
    color: Colors.accents[1],
    hasNavigation: true,
    location: '/settings/applayout',
  ),
  SettingItem(
    title: "Theme",
    icon: Iconsax.colorfilter,
    color: Colors.accents[2],
    hasNavigation: true,
    location: '/settings/theme',
  ),
  SettingItem(
    title: "Music and Playback",
    icon: Iconsax.music,
    color: Colors.accents[3],
    hasNavigation: true,
    location: '/settings/playback',
  ),
  SettingItem(
    title: "Download",
    icon: EvaIcons.download,
    color: Colors.accents[4],
    hasNavigation: true,
    location: '/settings/download',
  ),
  SettingItem(
    title: "History",
    icon: Icons.history,
    color: Colors.accents[5],
    hasNavigation: true,
    location: '/settings/history',
  )
];
List<SettingItem> appLayoutSettingDataList = [
  SettingItem(
    title: 'Right To Left',
    onTap: (context) => context.read<ThemeManager>().toggleTextDirection(),
    trailing: (context) => CupertinoSwitch(
      value: context.watch<ThemeManager>().isRightToLeftDirection,
      onChanged: (value) => context.read<ThemeManager>().toggleTextDirection(),
    ),
  ),
];
List<SettingItem> themesSettingDataList = [
  SettingItem(
    title: 'Primary Color',
    onTap: (context) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              "Pick Theme Color",
              style: textStyle(context).copyWith(fontSize: 18),
            ),
            message: BlockPicker(
              availableColors: const [
                accentColor,
                Color.fromRGBO(0, 123, 255, 1),
                Color.fromRGBO(40, 167, 69, 1),
                Color.fromRGBO(220, 53, 69, 1),
                Color.fromRGBO(255, 193, 7, 1),
                Color.fromRGBO(111, 66, 193, 1),
                Color.fromRGBO(253, 126, 20, 1),
                Color.fromRGBO(32, 201, 151, 1),
                Color.fromRGBO(233, 30, 99, 1),
                Color.fromRGBO(63, 81, 181, 1),
                Color.fromRGBO(0, 188, 212, 1),
                Color.fromRGBO(255, 193, 7, 1),
                Color.fromRGBO(103, 58, 183, 1),
                Color.fromRGBO(255, 87, 34, 1),
                Color.fromRGBO(205, 220, 57, 1),
              ],
              pickerColor: context.watch<ThemeManager>().accentColor,
              onColorChanged: (Color color) {
                context.read<ThemeManager>().setAccentColor(color);
              },
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done", style: smallTextStyle(context)),
              )
            ],
          );
        },
      );
    },
    trailing: (context) => Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: context.watch<ThemeManager>().accentColor,
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  ),
  SettingItem(
    title: 'Theme Mode',
    trailing: (context) {
      return DropdownButton2(
          style: textStyle(context, bold: false).copyWith(fontSize: 16),
          underline: const SizedBox(),
          value: context.watch<ThemeManager>().themeMode,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          ),
          iconStyleData: const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
          items: dropdownItems
              .map(
                (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString().split('.')[1].capitalize())),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            context.read<ThemeManager>().setThemeMode(value);
          });
    },
  ),
  SettingItem(
    title: 'Pitch Black',
    onTap: (context) => context.read<ThemeManager>().togglePitchBlack(),
    trailing: (context) => CupertinoSwitch(
      value: context.watch<ThemeManager>().isPitchBlack,
      onChanged: (value) => context.read<ThemeManager>().togglePitchBlack(),
    ),
  ),
  SettingItem(
    title: 'Material Colors',
    onTap: (context) => context.read<ThemeManager>().toggleMaterialTheme(),
    trailing: (context) => CupertinoSwitch(
      value: context.watch<ThemeManager>().isMaterialTheme,
      onChanged: (value) => context.read<ThemeManager>().toggleMaterialTheme(),
    ),
  ),
];

List<SettingItem> playbackSettingDataList = [
  SettingItem(
      title: 'Languages',
      trailing: (context) {
        return MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: darkGreyColor.withAlpha(50),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: Text(
                    "Select Languages",
                    style: textStyle(context).copyWith(fontSize: 18),
                  ),
                  message: Material(
                    color: Colors.transparent,
                    child: Column(
                        children: langs.map((lang) {
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(lang),
                        trailing: Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: context
                                .watch<ThemeManager>()
                                .languages
                                .contains(lang),
                            onChanged: (val) {
                              if (val != null) {
                                context
                                    .read<ThemeManager>()
                                    .toggleLanguage(lang, val);
                              }
                            }),
                      );
                    }).toList()),
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Done"))
                  ],
                );
              },
            );
          },
          child: const Text("Select"),
        );
      }),
  SettingItem(
    title: "Streaming Quality",
    trailing: (context) {
      Stream<BoxEvent> event = box.watch(key: 'streamingQuality');
      return StreamBuilder(
        stream: event,
        builder: (context, snapshot) => DropdownButton2<int>(
            style: textStyle(context, bold: false).copyWith(fontSize: 16),
            underline: const SizedBox(),
            value: snapshot.data?.value ??
                box.get('streamingQuality', defaultValue: 160),
            dropdownStyleData: DropdownStyleData(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
            iconStyleData: const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
            items: audioQualities
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text("$e kbps")),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              box.put('streamingQuality', value);
            }),
      );
    },
  ),
];

List<SettingItem> downloadSettingDatalist = [
  SettingItem(
    title: "Download Quality",
    trailing: (context) {
      Stream<BoxEvent> event = box.watch(key: 'downloadQuality');
      return StreamBuilder(
        stream: event,
        builder: (context, snapshot) => DropdownButton2<int>(
            style: textStyle(context, bold: false).copyWith(fontSize: 16),
            underline: const SizedBox(),
            value: snapshot.data?.value ??
                box.get('downloadQuality', defaultValue: 160),
            dropdownStyleData: DropdownStyleData(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
            iconStyleData: const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
            items: audioQualities
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text("$e kbps")),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              box.put('downloadQuality', value);
            }),
      );
    },
  ),
];

List<SettingItem> historySettingDatalist = [
  SettingItem(
      title: 'Enable Playback history',
      onTap: (context) async {
        bool isEnabled = box.get('playbackHistory', defaultValue: true);
        await box.put('playbackHistory', !isEnabled);
      },
      trailing: (context) {
        return ValueListenableBuilder(
          valueListenable: box.listenable(keys: ['playbackHistory']),
          builder: (context, value, child) {
            bool isEnabled = value.get('playbackHistory', defaultValue: true);
            return CupertinoSwitch(
                value: isEnabled,
                onChanged: (val) async {
                  await value.put('playbackHistory', val);
                });
          },
        );
      },
      subtitle: 'Recommeddations are based on the playback history.'),
  SettingItem(
      title: 'Delete Playback history',
      onTap: (context) async {
        await deletePlaybackHistory(context);
      },
      subtitle: 'Recommeddations are based on the playback history.')
];

List<ThemeMode> dropdownItems = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark
];

List<String> langs = [
  "English",
  "Urdu",
  "Hindi",
  "Punjabi",
  "Haryanvi",
  "Tamil",
  "Telugu",
  "Marathi",
  "Gujrati",
  "Bengali",
  "Kannada",
  "Bhojpuri",
  "Malayalam",
  "Rajasthani",
  "Odia",
  "Assamese",
];
List<int> audioQualities = [96, 160, 320];

Future<void> deletePlaybackHistory(BuildContext context) async {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure you want to delete playback history'),
      actions: [
        CupertinoDialogAction(
          child: const Text('No'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: const Text('Yes'),
          onPressed: () async {
            await Hive.box('songHistory')
                .clear()
                .then((value) => Navigator.pop(context))
                .then((value) => ShowSnackBar().showSnackBar(
                    context, 'Playback History Deleted.',
                    duration: const Duration(seconds: 2)));
          },
        ),
      ],
    ),
  );
}
