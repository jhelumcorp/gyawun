import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List socials = [
      {
        'icon': FontAwesomeIcons.github,
        'title': 'GitHub',
        'link': 'https://github.com/sheikhhaziq',
        'subtitle': S.of(context).Open_in_Browser
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'title': 'Twitter',
        'link': 'https://twitter.com/SheikhHaziq9',
        'subtitle': S.of(context).Open_in_Browser
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'title': 'Instagram',
        'link': 'https://www.instagram.com/rohan__rashid/',
        'subtitle': S.of(context).Open_in_Browser
      },
      {
        'icon': FontAwesomeIcons.discord,
        'title': 'Discord',
        'link': 'http://discord.gg/YtxYgGSYwN',
        'subtitle': S.of(context).Open_in_Browser
      },
    ];

    List troubleshooting = [
      {
        'icon': Icons.source_rounded,
        'title': 'Github',
        'subtitle': S.of(context).View_source_code,
        'link': 'https://github.com/sheikhhaziq/vibemusic'
      },
      {
        'icon': FontAwesomeIcons.bug,
        'title': S.of(context).Report_an_issue,
        'subtitle': S.of(context).github_redirect,
        'link':
            'https://github.com/sheikhhaziq/vibemusic/issues/new?assignees=&labels=bug&template=bug_report.yaml'
      },
      {
        'icon': Icons.request_page_rounded,
        'title': S.of(context).Request_a_feature,
        'subtitle': S.of(context).github_redirect,
        'link':
            'https://github.com/sheikhhaziq/vibemusic/issues/new?assignees=&labels=enhancement&template=feature_request.yaml'
      }
    ];

    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, child) {
        bool darkTheme = Theme.of(context).brightness == Brightness.dark;
        return Directionality(
          textDirection: box.get('textDirection', defaultValue: 'ltr') == 'rtl'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: darkTheme ? Colors.white : Colors.black,
                  )),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(S.of(context).About),
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
                            style:
                                Theme.of(context).primaryTextTheme.titleLarge,
                          ),
                          Text(
                            version,
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Text(
                        S.of(context).SOCIALS,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                                color: darkTheme ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      ...socials.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            onTap: () {
                              if (item['link'] != null) {
                                Uri url = Uri.parse(item['link']);
                                launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            leading: Icon(
                              item['icon'],
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                            title: Text(
                              item['title'],
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
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
                                          color: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                  ),
                            trailing: Icon(
                              Icons.open_in_browser_rounded,
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 30),
                      Text(
                        S.of(context).TROUBLESHOOTING,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                                color: darkTheme ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      ...troubleshooting.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            onTap: () {
                              if (item['link'] != null) {
                                Uri url = Uri.parse(item['link']);
                                launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            leading: Icon(
                              item['icon'],
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                            title: Text(
                              item['title'],
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
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
                                          color: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                  ),
                            trailing: Icon(
                              Icons.open_in_browser_rounded,
                              color: darkTheme ? Colors.black : Colors.white,
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
          ),
        );
      },
    );
  }
}
