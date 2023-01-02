import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/AudioQualityprovider.dart';
import 'package:vibe_music/providers/LanguageProvider.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';
import 'package:vibe_music/screens/AboutScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Map<String, String>> langs = [
    {"name": "English", "value": "en"},
    {"name": "French", "value": "fr"},
    {"name": "German", "value": "de"},
    {"name": "Hindi", "value": "hi"},
    {"name": "Japanese", "value": "ja"},
    {"name": "Portuguese", "value": "pt"},
    {"name": "Russian", "value": "ru"},
    {"name": "Spanish", "value": "es"},
    {"name": "Turkish", "value": "tr"},
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
                String value =
                    context.read<ThemeProvider>().themeMode == ThemeMode.dark
                        ? 'light'
                        : 'dark';
                context.read<ThemeProvider>().setTheme(value);
              },
              leading: Icon(
                Icons.dark_mode,
                color: darkTheme ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                S.of(context).Dark_Theme,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: CupertinoSwitch(
                  value: context.watch<ThemeProvider>().themeMode ==
                      ThemeMode.dark,
                  onChanged: (value) {
                    context
                        .read<ThemeProvider>()
                        .setTheme(value == true ? 'dark' : 'light');
                  }),
            ),
          ),
          // Dynamic theme
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () {
                bool value = context.read<ThemeProvider>().dynamicThemeMode;
                context.read<ThemeProvider>().setDynamicThemeMode(!value);
              },
              leading: Icon(
                Icons.style_rounded,
                color: darkTheme ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                S.of(context).Dynamic_Theme,
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                S.of(context).Experimental,
                style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: CupertinoSwitch(
                  value: context.watch<ThemeProvider>().dynamicThemeMode,
                  onChanged: (value) {
                    context.read<ThemeProvider>().setDynamicThemeMode(value);
                  }),
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
          )
        ],
      ),
    );
  }
}
