import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/screens/AboutScreen.dart';
import 'package:vibe_music/screens/HistoryScreen.dart';
import 'package:vibe_music/screens/ThemeScreen.dart';
import 'package:vibe_music/utils/checkUpdate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Map<String, String>> langs = [
    {"name": "Afrikaans", "value": "af"},
    {"name": "Arabic", "value": "ar"},
    {"name": "Chinese", "value": "zh"},
    {"name": "English", "value": "en"},
    {"name": "French", "value": "fr"},
    {"name": "German", "value": "de"},
    {"name": "Greek", "value": "el"},
    {"name": "Hindi", "value": "hi"},
    {"name": "Japanese", "value": "ja"},
    {"name": "Korean", "value": "ko"},
    {"name": "Odia", "value": "or"},
    {"name": "Portuguese", "value": "pt"},
    {"name": "Russian", "value": "ru"},
    {"name": "Spanish", "value": "es"},
    {"name": "Turkish", "value": "tr"},
    {"name": "Urdu", "value": "ur"}
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> audioQualities = [
      {"name": S.of(context).Low, "value": "low"},
      {"name": S.of(context).Medium, "value": "medium"},
      {"name": S.of(context).High, "value": "high"},
    ];
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: darkTheme ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(S.of(context).Settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, child) {
          bool darkTheme = Theme.of(context).brightness == Brightness.dark;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.translate_rounded,
                      color: darkTheme ? Colors.black : Colors.white,
                    ),
                    collapsedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: darkTheme ? Colors.black : Colors.white,
                    iconColor: darkTheme ? Colors.black : Colors.white,
                    collapsedIconColor: darkTheme ? Colors.black : Colors.white,
                    collapsedTextColor: darkTheme ? Colors.black : Colors.white,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).Language,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(
                          langs
                                  .where((element) =>
                                      element['value'] ==
                                      box.get('language_code',
                                          defaultValue: 'en'))
                                  .toList()[0]['name'] ??
                              "English",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.copyWith(
                                color: darkTheme ? Colors.black : Colors.white,
                              ),
                        ),
                      ],
                    ),
                    children: [
                      ...langs.map((lang) {
                        return Column(
                          children: [
                            ListTile(
                              hoverColor: Colors.black,
                              focusColor: Colors.black,
                              title: Text(
                                lang['name'] ?? "",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: darkTheme
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: box.get('language_code',
                                                    defaultValue: 'en') ==
                                                lang['value']
                                            ? FontWeight.bold
                                            : null),
                              ),
                              trailing: box.get('language_code',
                                          defaultValue: 'en') ==
                                      lang['value']
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                    )
                                  : null,
                              onTap: () {
                                box.put('language_code', lang['value']);
                              },
                            ),
                            if (lang['value'] != langs.last['value'])
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  height: 0.5,
                                  color: darkTheme
                                      ? const Color.fromARGB(255, 64, 64, 64)
                                      : const Color.fromARGB(255, 87, 137, 91),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    bool value =
                        box.get('textDirection', defaultValue: 'ltr') == 'rtl';
                    box.put('textDirection', value == false ? 'rtl' : 'ltr');
                  },
                  leading: Icon(
                    Icons.directions,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    S.of(context).RTL,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    S.of(context).Right_to_left_direction,
                    style:
                        Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
                              color: darkTheme ? Colors.black : Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  trailing: CupertinoSwitch(
                      value: box.get('textDirection', defaultValue: 'ltr') ==
                          'rtl',
                      onChanged: (value) {
                        box.put('textDirection', value == true ? 'rtl' : 'ltr');
                      }),
                ),
              ),
              // Location picker

              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    showCountryPicker(
                      countryFilter: [
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
                      ],
                      context: context,
                      onSelect: (Country value) {
                        box.put('countryName', value.name);
                        box.put('countryCode', value.countryCode);
                      },
                      countryListTheme: CountryListThemeData(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textStyle:
                            Theme.of(context).primaryTextTheme.titleLarge,
                        searchTextStyle:
                            Theme.of(context).primaryTextTheme.titleLarge,
                        borderRadius: BorderRadius.circular(10),
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height * (2 / 3),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.flag_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    S.of(context).Change_country,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  trailing: Text(
                    box.get('countryName', defaultValue: 'India'),
                    style:
                        Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                              color: darkTheme ? Colors.black : Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ExpansionTile(
                    leading: Icon(
                      CupertinoIcons.double_music_note,
                      color: darkTheme ? Colors.black : Colors.white,
                    ),
                    collapsedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: darkTheme ? Colors.black : Colors.white,
                    iconColor: darkTheme ? Colors.black : Colors.white,
                    collapsedIconColor: darkTheme ? Colors.black : Colors.white,
                    collapsedTextColor: darkTheme ? Colors.black : Colors.white,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).Audio_Quality,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(
                          audioQualities
                                  .where((element) =>
                                      element['value'] ==
                                      box.get('audioQuality',
                                          defaultValue: 'medium'))
                                  .toList()[0]['name'] ??
                              "Medium",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.copyWith(
                                color: darkTheme ? Colors.black : Colors.white,
                              ),
                        ),
                      ],
                    ),
                    children: audioQualities.map((quality) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              quality['name'] ?? "",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: box.get('audioQuality',
                                                  defaultValue: 'medium') ==
                                              quality['value']
                                          ? FontWeight.bold
                                          : null),
                            ),
                            trailing: box.get('audioQuality',
                                        defaultValue: 'medium') ==
                                    quality['value']
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
                                  )
                                : null,
                            onTap: () {
                              box.put('audioQuality', quality['value']);
                            },
                          ),
                          if (quality['value'] != audioQualities.last['value'])
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                height: .5,
                                color: darkTheme
                                    ? const Color.fromARGB(255, 64, 64, 64)
                                    : const Color.fromARGB(255, 87, 137, 91),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => ThemeScreen()));
                  },
                  title: Text(
                    S.of(context).Theme,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  leading: Icon(
                    Icons.color_lens_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => const HistoryScreen()));
                  },
                  title: Text(
                    S.of(context).History,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  leading: Icon(
                    Icons.history_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    showAlert(
                        context,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [CircularProgressIndicator()]));

                    checkUpdate().then((details) {
                      Navigator.pop(context);
                      if (details['isUpdate']) {
                        showUpdate(context, details['url']);
                      } else {
                        showAlert(
                            context,
                            Text(S.of(context).Already_updated,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium),
                            cancellable: false);
                      }
                    });
                  },
                  title: Text(
                    S.of(context).Update,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  leading: Icon(
                    Icons.update_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => const AboutScreen()));
                  },
                  title: Text(
                    S.of(context).About,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                          color: darkTheme ? Colors.black : Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  leading: Icon(
                    Icons.person_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
