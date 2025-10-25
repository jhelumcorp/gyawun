import 'package:flutter/material.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: FlutterLogo(size: 150),
                  ),

                  GroupTitle(title: "App Info"),
                  SettingTile(
                    isFirst: true,
                    title: "Gyawun Music",
                    leading: Icon(Icons.title_rounded),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Version",
                    leading: Icon(Icons.new_releases_rounded),
                    subtitle: "3.0.1",
                  ),
                  GroupTitle(title: "Developer"),
                  SettingTile(
                    isFirst: true,
                    title: "Developer",
                    leading: Icon(Icons.person_rounded),
                    subtitle: "Sheikh Haziq",
                    trailing: Icon(Icons.open_in_browser_rounded),

                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/sheikhhaziq"));
                    },
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Website",
                    leading: Icon(Icons.link_rounded),
                    trailing: Icon(Icons.open_in_browser_rounded),
                    onTap: () {
                      launchUrl(Uri.parse("https://gyawunmusic.vercel.app"));
                    },
                  ),
                  GroupTitle(title: "Community"),
                  SettingTile(
                    isFirst: true,
                    title: "Telegram",
                    leading: Icon(Icons.send_rounded),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Source code",
                    leading: Icon(Icons.code_rounded),
                  ),
                  
                  GroupTitle(title: "Support"),
                  SettingTile(
                    isFirst: true,
                    title: "Bug report",
                    leading: Icon(Icons.bug_report_rounded),
                  ),
                  SettingTile(
                    title: "Feature request",
                    leading: Icon(Icons.request_page_rounded),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Licenses",
                    leading: Icon(Icons.label_rounded),
                    onTap: () {
                      showLicensePage(context: context);
                    },
                  ),
                  SizedBox(height: 16),
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
