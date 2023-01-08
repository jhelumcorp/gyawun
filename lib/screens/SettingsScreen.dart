import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/AudioQualityprovider.dart';
import 'package:vibe_music/providers/LanguageProvider.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';
import 'package:vibe_music/screens/AboutScreen.dart';
import 'package:vibe_music/screens/ThemeScreen.dart';

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
    {"name": "Oriya", "value": "or"},
    {"name": "Portuguese", "value": "pt"},
    {"name": "Russian", "value": "ru"},
    {"name": "Spanish", "value": "es"},
    {"name": "Turkish", "value": "tr"},
    {"name": "Urdu", "value": "ur"}
  ];

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    List<Map<String, String>> audioQualities = [
      {"name": S.of(context).Low, "value": "low"},
      {"name": S.of(context).Medium, "value": "medium"},
      {"name": S.of(context).High, "value": "high"},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
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
                  color: darkTheme
                      ? Colors.white
                      : const Color.fromARGB(255, 58, 41, 86),
                ),
                collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: darkTheme ? Colors.white : Colors.black,
                iconColor: darkTheme ? Colors.white : Colors.black,
                collapsedIconColor: darkTheme ? Colors.white : Colors.black,
                collapsedTextColor: darkTheme ? Colors.white : Colors.black,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).Language,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      langs
                              .where((element) =>
                                  element['value'] ==
                                  context
                                      .watch<LanguageProvider>()
                                      .currentLocaleText)
                              .toList()[0]['name'] ??
                          "English",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
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
                                    fontWeight: context
                                                .watch<LanguageProvider>()
                                                .currentLocaleText ==
                                            lang['value']
                                        ? FontWeight.bold
                                        : null),
                          ),
                          trailing: context
                                      .watch<LanguageProvider>()
                                      .currentLocaleText ==
                                  lang['value']
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color:
                                      darkTheme ? Colors.white : Colors.black,
                                )
                              : null,
                          onTap: () {
                            context
                                .read<LanguageProvider>()
                                .setLocale(lang['value'] as String);
                          },
                        ),
                        if (lang['value'] != langs.last['value'])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                bool value = context.read<LanguageProvider>().textDirection ==
                    TextDirection.rtl;
                context
                    .read<LanguageProvider>()
                    .setTextDirection(value == false ? 'rtl' : 'ltr');
              },
              leading: Icon(
                Icons.directions,
                color: darkTheme ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                S.of(context).RTL,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                S.of(context).Right_to_left_direction,
                style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: CupertinoSwitch(
                  value: context.watch<LanguageProvider>().textDirection ==
                      TextDirection.rtl,
                  onChanged: (value) {
                    context
                        .read<LanguageProvider>()
                        .setTextDirection(value == true ? 'rtl' : 'ltr');
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
                    "IN",
                    "ZZ",
                    "AR",
                    "AU",
                    "AT",
                    "BE",
                    "BO",
                    "BR",
                    "CA",
                    "CL",
                    "CO",
                    "CR",
                    "CZ",
                    "DK",
                    "DO",
                    "EC",
                    "EG",
                    "SV",
                    "EE",
                    "FI",
                    "FR",
                    "DE",
                    "GT",
                    "HN",
                    "HU",
                    "IS",
                    "ID",
                    "IE",
                    "IL",
                    "IT",
                    "JP",
                    "KE",
                    "LU",
                    "MX",
                    "NL",
                    "NZ",
                    "NI",
                    "NG",
                    "NO",
                    "PA",
                    "PY",
                    "PE",
                    "PL",
                    "PT",
                    "RO",
                    "RU",
                    "SA",
                    "RS",
                    "ZA",
                    "KR",
                    "ES",
                    "SE",
                    "CH",
                    "TZ",
                    "TR",
                    "UG",
                    "UA",
                    "AE",
                    "GB",
                    "US",
                    "UY",
                    "ZW"
                  ],
                  context: context,
                  onSelect: (Country value) {
                    context
                        .read<LanguageProvider>()
                        .setCountry(name: value.name, code: value.countryCode);
                  },
                  countryListTheme: CountryListThemeData(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    textStyle: Theme.of(context).primaryTextTheme.titleLarge,
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
                color: darkTheme ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                S.of(context).Change_country,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: Text(
                context.watch<LanguageProvider>().countryName,
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
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
                leading: Icon(CupertinoIcons.double_music_note,
                    color: darkTheme ? Colors.white : Colors.black),
                collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: darkTheme ? Colors.white : Colors.black,
                iconColor: darkTheme ? Colors.white : Colors.black,
                collapsedIconColor: darkTheme ? Colors.white : Colors.black,
                collapsedTextColor: darkTheme ? Colors.white : Colors.black,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).Audio_Quality,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      audioQualities
                              .where((element) =>
                                  element['value'] ==
                                  context.watch<AudioQualityProvider>().quality)
                              .toList()[0]['name'] ??
                          "English",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
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
                                  fontWeight: context
                                              .watch<LanguageProvider>()
                                              .currentLocaleText ==
                                          quality['value']
                                      ? FontWeight.bold
                                      : null),
                        ),
                        trailing: context
                                    .watch<AudioQualityProvider>()
                                    .quality ==
                                quality['value']
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: darkTheme ? Colors.white : Colors.black,
                              )
                            : null,
                        onTap: () {
                          context
                              .read<AudioQualityProvider>()
                              .setQuality(quality['value'] as String);
                        },
                      ),
                      if (quality['value'] != audioQualities.last['value'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ThemeScreen()));
              },
              title: Text(
                S.of(context).Theme,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              leading: Icon(
                Icons.color_lens_rounded,
                color: darkTheme ? Colors.white : Colors.black,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
              title: Text(
                S.of(context).About,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              leading: Icon(
                Icons.person_rounded,
                color: darkTheme ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
