import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_config.dart';
import '../../../generated/l10n.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(icon: Icons.title, color: null),
                      title: Text(
                        "Gyawun Music",
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Text(
                        S.of(context).Gyawun,
                        style: smallTextStyle(context),
                      ),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: Icons.new_releases),
                      title: Text(
                        S.of(context).Version,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Text(
                        appConfig.codeName,
                        style: smallTextStyle(context),
                      ),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: CupertinoIcons.person),
                      title: Text(
                        S.of(context).Developer,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            S.of(context).Sheikh_Haziq,
                            style: smallTextStyle(context),
                          ),
                          const SizedBox(width: 8),
                          Icon(AdaptiveIcons.chevron_right)
                        ],
                      ),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/sheikhhaziq'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: Icons.other_houses),
                      title: Text(
                        S.of(context).Organisation,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            S.of(context).Jhelum_Corp,
                            style: smallTextStyle(context),
                          ),
                          const SizedBox(width: 8),
                          Icon(AdaptiveIcons.chevron_right)
                        ],
                      ),
                      onTap: () => launchUrl(
                          Uri.parse('https://jhelumcorp.github.io'),
                          mode: LaunchMode.externalApplication),
                    ),
                     AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: Icons.link),
                      title: Text(
                        "Website",
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://gyawunmusic.vercel.app'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: Icons.telegram_outlined),
                      title: Text(
                        S.of(context).Telegram,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://t.me/jhelumcorp'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: CupertinoIcons.person_3),
                      title: Text(
                        S.of(context).Contributors,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/contributors'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(color: null, icon: Icons.code),
                      title: Text(
                        S.of(context).Source_Code,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/jhelumcorp/gyawun'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading:
                          const ColorIcon(color: null, icon: Icons.bug_report),
                      title: Text(
                        S.of(context).Bug_Report,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/issues/new?assignees=&labels=bug&projects=&template=bug_report.yaml'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const ColorIcon(
                          color: null, icon: Icons.request_page),
                      title: Text(
                        S.of(context).Feature_Request,
                        style: textStyle(context, bold: false)
                            .copyWith(fontSize: 16),
                      ),
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
