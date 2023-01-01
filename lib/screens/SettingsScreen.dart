import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/AudioQualityprovider.dart';
import 'package:vibe_music/providers/LanguageProvider.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Map<String, String>> langs = [
    {"name": "English", "value": "en"},
    {"name": "French", "value": "fr"},
    {"name": "Hindi", "value": "hi"},
    {"name": "Japanese", "value": "ja"},
    {"name": "Portuguese", "value": "pt"},
    {"name": "Russian", "value": "ru"},
    {"name": "Spanish", "value": "es"},
  ];

  @override
  Widget build(BuildContext context) {
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
                leading: const Icon(
                  Icons.language_rounded,
                  color: Color.fromARGB(255, 58, 41, 86),
                ),
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 136, 240, 196),
                backgroundColor: const Color.fromARGB(255, 136, 240, 196),
                textColor: Colors.black,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                collapsedTextColor: Colors.black,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).Language,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(langs
                            .where((element) =>
                                element['value'] ==
                                context
                                    .watch<LanguageProvider>()
                                    .currentLocaleText)
                            .toList()[0]['name'] ??
                        "English"),
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
                            style: TextStyle(
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
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.black,
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
                              color: const Color.fromARGB(255, 87, 137, 91),
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
                leading: const Icon(
                  CupertinoIcons.double_music_note,
                  color: Color.fromARGB(255, 58, 41, 86),
                ),
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 136, 240, 196),
                backgroundColor: const Color.fromARGB(255, 136, 240, 196),
                textColor: Colors.black,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                collapsedTextColor: Colors.black,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).Audio_Quality,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(audioQualities
                            .where((element) =>
                                element['value'] ==
                                context.watch<AudioQualityProvider>().quality)
                            .toList()[0]['name'] ??
                        "English"),
                  ],
                ),
                children: audioQualities.map((quality) {
                  return Column(
                    children: [
                      ListTile(
                        hoverColor: Colors.black,
                        focusColor: Colors.black,
                        title: Text(
                          quality['name'] ?? "",
                          style: TextStyle(
                              fontWeight: context
                                          .watch<LanguageProvider>()
                                          .currentLocaleText ==
                                      quality['value']
                                  ? FontWeight.bold
                                  : null),
                        ),
                        trailing:
                            context.watch<AudioQualityProvider>().quality ==
                                    quality['value']
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.black,
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
                            color: const Color.fromARGB(255, 87, 137, 91),
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
              leading: const Icon(
                Icons.colorize_rounded,
                color: Color.fromARGB(255, 58, 41, 86),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: const Color.fromARGB(255, 136, 240, 196),
              title: Text(
                S.of(context).Dark_Theme,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: CupertinoSwitch(
                  value: context.watch<ThemeProvider>().themeMode == 'dark',
                  onChanged: (value) {
                    context
                        .read<ThemeProvider>()
                        .setTheme(value == true ? 'dark' : 'light');
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
