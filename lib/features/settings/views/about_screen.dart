import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const FlutterLogo(size: 150),
                  ),

                  const GroupTitle(title: "App Info"),
                  const SettingTile(
                    isFirst: true,
                    title: "Gyawun Music",
                    leading: Icon(FluentIcons.text_32_filled),
                  ),
                  const SettingTile(
                    isLast: true,
                    title: "Version",
                    leading: Icon(Icons.new_releases_rounded),
                    subtitle: "3.0.1",
                  ),
                  const GroupTitle(title: "Developer"),
                  SettingTile(
                    isFirst: true,
                    title: "Developer",
                    leading: const Icon(FluentIcons.person_24_filled),
                    subtitle: "Sheikh Haziq",
                    trailing: const Icon(FluentIcons.open_24_filled),

                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/sheikhhaziq"));
                    },
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Website",
                    leading: const Icon(FluentIcons.link_24_filled),
                    trailing: const Icon(FluentIcons.open_24_filled),
                    onTap: () {
                      launchUrl(Uri.parse("https://gyawunmusic.vercel.app"));
                    },
                  ),
                  const GroupTitle(title: "Community"),
                  const SettingTile(
                    isFirst: true,
                    title: "Telegram",
                    leading: Icon(Icons.send_rounded),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Source code",
                    leading: const Icon(FluentIcons.code_24_filled),
                    trailing: const Icon(FluentIcons.open_24_filled),

                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/sheikhhaziq/gyawun"));
                    },
                  ),

                  const GroupTitle(title: "Support"),
                  const SettingTile(
                    isFirst: true,
                    title: "Bug report",
                    leading: Icon(FluentIcons.bug_24_filled),
                  ),
                  const SettingTile(
                    title: "Feature request",
                    leading: Icon(FluentIcons.new_24_filled),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Licenses",
                    leading: const Icon(FluentIcons.document_24_filled),
                    onTap: () {
                      showLicensePage(context: context);
                    },
                  ),
                  const BottomPlayingPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
