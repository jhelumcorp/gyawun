import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List socials = [
      {
        'icon': FontAwesomeIcons.github,
        'title': 'GitHub',
        'link': 'https://github.com/sheikhhaziq',
        'subtitle': 'Open in browser'
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'title': 'Twitter',
        'link': 'https://twitter.com/SheikhHaziq9',
        'subtitle': 'Open in browser'
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'title': 'Instagram',
        'link': 'https://www.instagram.com/rohan__rashid/',
        'subtitle': 'Open in browser'
      },
    ];

    List troubleshooting = [
      {
        'icon': Icons.source_rounded,
        'title': 'Github',
        'subtitle': 'View the source code',
        'link': 'https://github.com/sheikhhaziq/vibemusic'
      },
      {
        'icon': FontAwesomeIcons.bug,
        'title': 'Report an issue',
        'subtitle': 'You will be redirected to Github',
        'link':
            'https://github.com/sheikhhaziq/vibemusic/issues/new?assignees=&labels=bug&template=bug_report.yaml'
      },
      {
        'icon': Icons.request_page_rounded,
        'title': 'Request a feature',
        'subtitle': 'You will be redirected to Github',
        'link':
            'https://github.com/sheikhhaziq/vibemusic/issues/new?assignees=&labels=enhancement&template=feature_request.yaml'
      }
    ];
    bool isDarkTheme =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: isDarkTheme ? Colors.white : Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("About"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/images/logo.png')),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Vibe Music ",
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                    ),
                    Text(
                      '0.4.2',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  "SOCIALS",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleMedium
                      ?.copyWith(
                          color: isDarkTheme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                ),
                ...socials.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      onTap: () {
                        if (item['link'] != null) {
                          Uri url = Uri.parse(item['link']);
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      leading: Icon(
                        item['icon'],
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        item['title'],
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: item['subtitle'] == null
                          ? null
                          : Text(
                              item['subtitle'],
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodySmall
                                  ?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                      trailing: Icon(
                        Icons.open_in_browser_rounded,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }).toList(),
                const SizedBox(height: 30),
                Text(
                  "TROUBLESHOOTING",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleMedium
                      ?.copyWith(
                          color: isDarkTheme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                ),
                ...troubleshooting.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      onTap: () {
                        if (item['link'] != null) {
                          Uri url = Uri.parse(item['link']);
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      leading: Icon(
                        item['icon'],
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        item['title'],
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: item['subtitle'] == null
                          ? null
                          : Text(
                              item['subtitle'],
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodySmall
                                  ?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                      trailing: Icon(
                        Icons.open_in_browser_rounded,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
