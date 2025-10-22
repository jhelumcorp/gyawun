import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_config.dart';
import '../../../generated/l10n.dart';
import '../../../themes/colors.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../color_icon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).About),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon.png',
                          height: 100,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: darkGreyColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingTile(
                      leading: const Icon( Icons.title),
                      title:"Gyawun Music",
                      isFirst: true,
                      
                    ),
                    SettingTile(
                      leading: const Icon(Icons.new_releases),
                      title: S.of(context).Version,
                      subtitle: appConfig.codeName,
                    ),
                    SettingTile(
                      leading: const Icon(CupertinoIcons.person),
                      title: S.of(context).Developer,
                      subtitle: S.of(context).Sheikh_Haziq,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/sheikhhaziq'),
                          mode: LaunchMode.externalApplication),
                    ),
                    SettingTile(
                      leading: const ColorIcon(
                          color: null, icon: Icons.other_houses),
                      title: S.of(context).Organisation,
                      subtitle: S.of(context).Jhelum_Corp,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://jhelumcorp.github.io'),
                          mode: LaunchMode.externalApplication),
                    ),
                     SettingTile(
                      leading: const ColorIcon(
                          color: null, icon: Icons.link),
                      title: "Website",
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://gyawunmusic.vercel.app'),
                          mode: LaunchMode.externalApplication),
                    ),
                    SettingTile(
                      leading: const ColorIcon(
                          color: null, icon: Icons.telegram_outlined),
                      title: S.of(context).Telegram,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://t.me/jhelumcorp'),
                          mode: LaunchMode.externalApplication),
                    ),
                    SettingTile(
                      leading: const ColorIcon(
                          color: null, icon: CupertinoIcons.person_3),
                      title: S.of(context).Contributors,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/contributors'),
                          mode: LaunchMode.externalApplication),
                    ),
                    SettingTile(
                      leading: const ColorIcon(color: null, icon: Icons.code),
                      title: S.of(context).Source_Code,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/jhelumcorp/gyawun'),
                          mode: LaunchMode.externalApplication),
                    ),
                     
                    SettingTile(
                      leading:
                          const ColorIcon(color: null, icon: Icons.bug_report),
                      title: S.of(context).Bug_Report,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/issues/new?assignees=&labels=bug&projects=&template=bug_report.yaml'),
                          mode: LaunchMode.externalApplication),
                    ),
                    SettingTile(
                      leading: const ColorIcon(
                          color: null, icon: Icons.request_page),
                      title: S.of(context).Feature_Request,
                      isLast: true,
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/issues/new?assignees=sheikhhaziq&labels=enhancement%2CFeature+Request&projects=&template=feature_request.yaml'),
                          mode: LaunchMode.externalApplication),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(S.of(context).Made_In_Kashmir),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
