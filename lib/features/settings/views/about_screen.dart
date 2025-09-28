import 'package:flutter/material.dart';
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

                  SizedBox(height: 16),
                  SettingTile(
                    isFirst: true,
                    title: "Gyawun Music",
                    leading: Icon(Icons.title_rounded),
                  ),
                  SettingTile(
                    title: "Version",
                    leading: Icon(Icons.new_releases_rounded),
                    subtitle: "3.0.1",
                  ),
                  SettingTile(
                    title: "Developer",
                    leading: Icon(Icons.person_rounded),
                    subtitle: "Sheikh Haziq",
                    trailing: Icon(Icons.open_in_browser_rounded),

                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/sheikhhaziq"));
                    },
                  ),
                  SettingTile(
                    title: "Website",
                    leading: Icon(Icons.link_rounded),
                    trailing: Icon(Icons.open_in_browser_rounded),
                    onTap: () {
                      launchUrl(Uri.parse("https://gyawunmusic.vercel.app"));
                    },
                  ),
                  SettingTile(
                    title: "Telegram",
                    leading: Icon(Icons.send_rounded),
                  ),
                  SettingTile(
                    title: "Source code",
                    leading: Icon(Icons.code_rounded),
                  ),
                  SettingTile(
                    title: "Licenses",
                    leading: Icon(Icons.label_rounded),
                    onTap: () {
                      showLicensePage(context: context);
                    },
                  ),

                  SettingTile(
                    title: "Bug report",
                    leading: Icon(Icons.bug_report_rounded),
                  ),
                  SettingTile(
                    title: "Feature request",
                    leading: Icon(Icons.request_page_rounded),
                    isLast: true,
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
