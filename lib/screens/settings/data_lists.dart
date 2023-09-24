import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/api/extensions.dart';
import 'package:gyawun/models/setting_item.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/providers/theme_manager.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/format_duration.dart';
import 'package:gyawun/utils/playback_cache.dart';
import 'package:gyawun/utils/snackbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

Box box = Hive.box('settings');

List<SettingItem> allDataLists(BuildContext context) => [
      ...[
        ...appAppearenceSettingDataList(context),
        ...playbackSettingDataList(context),
        ...providersSettingDatalist(context),
        ...downloadSettingDatalist(context),
        ...historySettingDatalist(context),
      ]..sort((a, b) => a.title.compareTo(b.title)),
      ...List.from(mainSettingDataList(context))
        ..sort((a, b) => a.title.compareTo(b.title)),
    ];

List<SettingItem> mainSettingDataList(BuildContext context) => [
      SettingItem(
          title: S.of(context).sleepTimer,
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
        title: S.of(context).country,
        icon: Iconsax.location,
        color: Colors.accents[1],
        hasNavigation: false,
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: box.listenable(keys: ['locationName']),
            builder: (context, value, child) {
              return Text(
                value.get('locationName', defaultValue: 'India'),
                style: smallTextStyle(context),
              );
            },
          );
        },
        onTap: (context) {
          showCountryPicker(
            context: context,
            countryFilter: countries,
            onSelect: (value) {
              box.put('locationName', value.name);
              box.put('locationCode', value.countryCode);
            },
            countryListTheme: CountryListThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              textStyle: Theme.of(context).primaryTextTheme.titleLarge,
              searchTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
              borderRadius: BorderRadius.circular(10),
              bottomSheetHeight: MediaQuery.of(context).size.height * (2 / 3),
            ),
          );
        },
      ),
      SettingItem(
        title: S.of(context).appearence,
        icon: EvaIcons.layout,
        color: Colors.accents[2],
        hasNavigation: true,
        location: '/settings/appearence',
      ),
      SettingItem(
        title: S.of(context).musicAndPlayback,
        icon: Iconsax.music,
        color: Colors.accents[4],
        hasNavigation: true,
        location: '/settings/playback',
      ),
      SettingItem(
        title: S.of(context).serviceProviders,
        icon: Icons.data_object_rounded,
        color: Colors.accents[5],
        hasNavigation: true,
        location: '/settings/providers',
      ),
      SettingItem(
        title: S.of(context).download,
        icon: EvaIcons.download,
        color: Colors.accents[6],
        hasNavigation: true,
        location: '/settings/download',
      ),
      SettingItem(
        title: S.of(context).history,
        icon: Icons.history,
        color: Colors.accents[15],
        hasNavigation: true,
        location: '/settings/history',
      ),
      SettingItem(
        title: S.of(context).about,
        icon: Icons.info_rounded,
        color: Colors.accents[3],
        hasNavigation: true,
        location: '/settings/about',
      ),
    ];
List<SettingItem> appAppearenceSettingDataList(BuildContext context) => [
      SettingItem(
        title: S.of(context).languages,
        trailing: (context) {
          return Text(context.watch<ThemeManager>().language['name'],
              style: smallTextStyle(context));
        },
        onTap: (context) {
          showlanguagePage(context);
        },
      ),
      SettingItem(
        title: S.of(context).rightToLeft,
        onTap: (context) => context.read<ThemeManager>().toggleTextDirection(),
        trailing: (context) => CupertinoSwitch(
          value: context.watch<ThemeManager>().isRightToLeftDirection,
          onChanged: (value) =>
              context.read<ThemeManager>().toggleTextDirection(),
        ),
      ),
      SettingItem(
        title: S.of(context).primaryColor,
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
        title: S.of(context).themeMode,
        trailing: (context) {
          return DropdownButton2(
              style: textStyle(context, bold: false).copyWith(fontSize: 16),
              underline: const SizedBox(),
              value: context.watch<ThemeManager>().themeMode,
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
              ),
              iconStyleData:
                  const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
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
        title: S.of(context).pitchBlack,
        onTap: (context) => context.read<ThemeManager>().togglePitchBlack(),
        trailing: (context) => CupertinoSwitch(
          value: context.watch<ThemeManager>().isPitchBlack,
          onChanged: (value) => context.read<ThemeManager>().togglePitchBlack(),
        ),
      ),
      SettingItem(
        title: S.of(context).materialColors,
        onTap: (context) => context.read<ThemeManager>().toggleMaterialTheme(),
        trailing: (context) => CupertinoSwitch(
          value: context.watch<ThemeManager>().isMaterialTheme,
          onChanged: (value) =>
              context.read<ThemeManager>().toggleMaterialTheme(),
        ),
      ),
    ];

List<SettingItem> playbackSettingDataList(BuildContext context) => [
      SettingItem(
        title: S.of(context).loudnessAndEquilizer,
        hasNavigation: true,
        location: '/settings/playback/equilizer',
      ),
      SettingItem(
          title: S.of(context).languages,
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
        title: S.of(context).streamingQuality,
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
                iconStyleData:
                    const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
                items: audioQualities
                    .map(
                      (e) => DropdownMenuItem(
                          value: e,
                          child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text("$e kbps"))),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  box.put('streamingQuality', value);
                }),
          );
        },
      ),
      SettingItem(
        title: S.of(context).youtubeStreamingQuality,
        trailing: (context) {
          Stream<BoxEvent> event = box.watch(key: 'youtubeStreamingQuality');
          return StreamBuilder(
            stream: event,
            builder: (context, snapshot) => DropdownButton2<String>(
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
                underline: const SizedBox(),
                value: snapshot.data?.value ??
                    box.get('youtubeStreamingQuality', defaultValue: 'Medium'),
                dropdownStyleData: DropdownStyleData(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                ),
                iconStyleData:
                    const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
                items: youtubeAudioQualities
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  box.put('youtubeStreamingQuality', value);
                }),
          );
        },
      ),

      SettingItem(
        title: S.of(context).enablePlaybackCache,
        onTap: (context) async {
          bool isEnabled = box.get('playbackCache', defaultValue: false);
          await box.put('playbackCache', !isEnabled);
        },
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: box.listenable(keys: ['playbackCache']),
            builder: (context, value, child) {
              bool isEnabled = value.get('playbackCache', defaultValue: false);
              return CupertinoSwitch(
                value: isEnabled,
                onChanged: (val) async {
                  await value.put('playbackCache', val);
                },
              );
            },
          );
        },
      ),
      SettingItem(
          title: S.of(context).clearPlaybackCache,
          onTap: (context) async {
            await clearPlaybackCache(context);
          },
          trailing: (context) {
            return ValueListenableBuilder(
                valueListenable: GetIt.I<PlaybackCache>().cachesize,
                builder: (context, value, child) {
                  return Text(value, style: smallTextStyle(context));
                });
          })
      // 'playbackCache'
    ];
List<SettingItem> providersSettingDatalist(BuildContext context) => [
      SettingItem(
        title: S.of(context).homescreenProvider,
        trailing: (context) {
          return ValueListenableBuilder(
            valueListenable: box.listenable(keys: ['homescreenProvider']),
            builder: (context, value, child) {
              return DropdownButton2(
                underline: const SizedBox(),
                value: value.get('homescreenProvider', defaultValue: 'saavn'),
                items: const [
                  DropdownMenuItem(value: 'saavn', child: Text('Saavn')),
                  DropdownMenuItem(value: 'youtube', child: Text('YouTube')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    value.put('homescreenProvider', val);
                  }
                },
              );
            },
          );
        },
      ),
      SettingItem(
        title: S.of(context).searchProvider,
        trailing: (context) {
          Stream<BoxEvent> event = box.watch(key: 'searchProvider');
          return StreamBuilder(
            stream: event,
            builder: (context, snapshot) => DropdownButton2<String>(
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
                underline: const SizedBox(),
                value: snapshot.data?.value ??
                    box.get('searchProvider', defaultValue: 'saavn'),
                dropdownStyleData: DropdownStyleData(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                ),
                iconStyleData:
                    const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
                items: const [
                  DropdownMenuItem(value: 'saavn', child: Text('Saavn')),
                  DropdownMenuItem(value: 'youtube', child: Text('YouTube'))
                ],
                onChanged: (value) {
                  if (value == null) return;
                  box.put('searchProvider', value);
                }),
          );
        },
      ),
    ];

List<SettingItem> downloadSettingDatalist(BuildContext context) => [
      SettingItem(
        title: S.of(context).downloadQuality,
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
                iconStyleData:
                    const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
                items: audioQualities
                    .map(
                      (e) => DropdownMenuItem(
                          value: e,
                          child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text("$e kbps"))),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  box.put('downloadQuality', value);
                }),
          );
        },
      ),
      SettingItem(
        title: S.of(context).youtubeDownloadQuality,
        trailing: (context) {
          Stream<BoxEvent> event = box.watch(key: 'youtubeDownloadQuality');
          return StreamBuilder(
            stream: event,
            builder: (context, snapshot) => DropdownButton2<String>(
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
                underline: const SizedBox(),
                value: snapshot.data?.value ??
                    box.get('youtubeDownloadQuality', defaultValue: 'Medium'),
                dropdownStyleData: DropdownStyleData(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                ),
                iconStyleData:
                    const IconStyleData(icon: Icon(EvaIcons.arrowDown)),
                items: youtubeAudioQualities
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  box.put('youtubeDownloadQuality', value);
                }),
          );
        },
      ),
    ];

List<SettingItem> historySettingDatalist(BuildContext context) => [
      SettingItem(
        title: S.of(context).enablePlaybackHistory,
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
        subtitle: S.of(context).enablePlaybackHistoryText,
      ),
      SettingItem(
        title: S.of(context).deletePlaybackHistory,
        onTap: (context) async {
          await deletePlaybackHistory(context);
        },
        subtitle: S.of(context).deletePlaybackHistoryText,
      ),
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
List<String> countries = [
  "KR",
  "GH",
  "KW",
  "LS",
  "ZM",
  "AL",
  "QA",
  "AM",
  "BB",
  "BO",
  "EE",
  "VE",
  "ME",
  "BW",
  "PT",
  "NO",
  "ZA",
  "SA",
  "TL",
  "ES",
  "SE",
  "SB",
  "LR",
  "EG",
  "BZ",
  "SG",
  "BM",
  "GL",
  "ML",
  "IM",
  "PE",
  "NL",
  "TM",
  "AF",
  "DK",
  "CW",
  "CH",
  "GS",
  "RU",
  "TF",
  "NE",
  "NG",
  "BS",
  "BT",
  "KY",
  "SH",
  "SL",
  "KZ",
  "TK",
  "FK",
  "TV",
  "CC",
  "GM",
  "KG",
  "MA",
  "SS",
  "VI",
  "SY",
  "AO",
  "ST",
  "JO",
  "SZ",
  "CK",
  "HT",
  "FI",
  "NU",
  "UZ",
  "SV",
  "MK",
  "AG",
  "VG",
  "CR",
  "VC",
  "VN",
  "TZ",
  "LK",
  "PA",
  "TH",
  "CA",
  "HR",
  "LT",
  "SX",
  "CF",
  "PL",
  "BH",
  "PG",
  "EC",
  "MO",
  "KI",
  "TC",
  "GG",
  "BD",
  "PM",
  "AZ",
  "CY",
  "LV",
  "FO",
  "BL",
  "TJ",
  "GY",
  "LU",
  "AW",
  "MF",
  "MU",
  "NP",
  "YE",
  "AE",
  "EH",
  "ZW",
  "PW",
  "KP",
  "SJ",
  "WS",
  "BQ",
  "TR",
  "DZ",
  "GI",
  "NC",
  "CL",
  "SI",
  "TD",
  "AR",
  "MR",
  "BR",
  "UY",
  "IS",
  "CU",
  "MS",
  "GD",
  "LB",
  "DO",
  "AD",
  "SN",
  "CO",
  "NA",
  "MV",
  "MN",
  "RS",
  "BN",
  "KH",
  "MP",
  "PH",
  "PN",
  "RW",
  "CG",
  "MX",
  "HU",
  "PY",
  "DM",
  "MQ",
  "AU",
  "MY",
  "SK",
  "US",
  "HK",
  "YT",
  "BG",
  "PK",
  "HM",
  "OM",
  "TG",
  "GB",
  "ER",
  "JE",
  "LA",
  "TO",
  "FJ",
  "AT",
  "MZ",
  "AQ",
  "PF",
  "AI",
  "IN",
  "MC",
  "ET",
  "MH",
  "NR",
  "CV",
  "KN",
  "PR",
  "KE",
  "BA",
  "MG",
  "GR",
  "IT",
  "VA",
  "WF",
  "IE",
  "GF",
  "MD",
  "BV",
  "SO",
  "FR",
  "NF",
  "SC",
  "MW",
  "AX",
  "GQ",
  "PS",
  "LC",
  "KM",
  "RO",
  "MT",
  "GA",
  "CX",
  "CZ",
  "GP",
  "LI",
  "UM",
  "VU",
  "GU",
  "RE",
  "DJ",
  "HN",
  "AS",
  "GT",
  "UA",
  "IO",
  "MM",
  "FM",
  "LY",
  "GE",
  "CN",
  "DE",
  "IL",
  "GW",
  "JM",
  "SM",
  "JP",
  "UG",
  "TN",
  "BE",
  "CD",
  "ID",
  "IR",
  "NI",
  "SD",
  "BF",
  "NZ",
  "CI",
  "CM",
  "BI",
  "SR",
  "GN",
  "IQ",
  "TT",
  "TW",
  "BJ",
  "BY"
];
List<int> audioQualities = [96, 160, 320];
List<String> youtubeAudioQualities = ['Low', 'Medium', 'High'];

Future<void> deletePlaybackHistory(BuildContext context) async {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(S.of(context).confirm),
      content: Text(S.of(context).deletePlaybackHistoryDialogText),
      actions: [
        CupertinoDialogAction(
          child: Text(S.of(context).no),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text(S.of(context).yes),
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

clearPlaybackCache(context) async {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(S.of(context).confirm),
      content: Text(S.of(context).clearPlaybackCacheDialogText),
      actions: [
        CupertinoDialogAction(
          child: Text(S.of(context).no),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text(S.of(context).yes),
          onPressed: () async {
            await GetIt.I<PlaybackCache>()
                .clearCache()
                .then((value) => Navigator.pop(context))
                .then((value) => ShowSnackBar().showSnackBar(
                    context, 'Playback Cache Deleted.',
                    duration: const Duration(seconds: 2)));
          },
        ),
      ],
    ),
  );
}

showlanguagePage(BuildContext context) {
  List<Map<String, dynamic>> languages =
      context.read<ThemeManager>().supportedLanguages;
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: Text(
          S.of(context).selectLanguage,
          style: textStyle(context).copyWith(fontSize: 18),
        ),
        message: Material(
          color: Colors.transparent,
          child: Column(children: [
            ...languages.map((lang) {
              return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(lang['name'].toString().capitalize()),
                  trailing: context
                              .watch<ThemeManager>()
                              .language['code']
                              .toLowerCase() ==
                          lang['code'].toString().toLowerCase()
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () async {
                    await context
                        .read<ThemeManager>()
                        .setLanguage(lang['code'].toString().toLowerCase())
                        .then((value) => Navigator.pop(context));
                  });
            }).toList()
          ]),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"))
        ],
      );
    },
  );
}

String qualities(BuildContext context, name) {
  Map q = {
    'High': S.of(context).high,
    'Medium': S.of(context).medium,
    'Low': S.of(context).low
  };
  return q[name];
}
