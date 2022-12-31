import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/AudioQualityprovider.dart';
import 'package:vibe_music/providers/LanguageProvider.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: Color.fromARGB(255, 58, 41, 86),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: const Color.fromARGB(255, 136, 240, 196),
              title: Text(
                S.of(context).Language,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: DropdownButton(
                value: context.watch<LanguageProvider>().currentLocaleText,
                items: [
                  DropdownMenuItem(
                    value: "en",
                    child: Text(
                      "English",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "fr",
                    child: Text(
                      "French",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "hi",
                    child: Text(
                      "Hindi",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "ja",
                    child: Text(
                      "Japanese",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "pt",
                    child: Text(
                      "Portuguese",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "ru",
                    child: Text(
                      "Russian",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "es",
                    child: Text(
                      "Spanish",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodySmall
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  context.read<LanguageProvider>().setLocale(value as String);
                },
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
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: Color.fromARGB(255, 58, 41, 86),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: const Color.fromARGB(255, 136, 240, 196),
              title: Text(
                S.of(context).Audio_Quality,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: DropdownButton(
                  value: context.watch<AudioQualityProvider>().quality,
                  onChanged: (value) {
                    context.read<AudioQualityProvider>().setQuality(value);
                  },
                  items: [
                    DropdownMenuItem(
                      value: "low",
                      child: Text(
                        S.of(context).Low,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodySmall
                            ?.copyWith(
                                overflow: TextOverflow.ellipsis, fontSize: 16),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "medium",
                      child: Text(
                        S.of(context).Medium,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodySmall
                            ?.copyWith(
                                overflow: TextOverflow.ellipsis, fontSize: 16),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "high",
                      child: Text(
                        S.of(context).High,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodySmall
                            ?.copyWith(
                                overflow: TextOverflow.ellipsis, fontSize: 16),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
