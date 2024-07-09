import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_config.dart';
import '../../../generated/l10n.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).about),
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
                      leading: const Icon(Icons.title),
                      title: Text(
                        S.of(context).name,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Text(
                        S.of(context).gyawun,
                        style: smallTextStyle(context),
                      ),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(Icons.new_releases),
                      title: Text(
                        S.of(context).version,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Text(
                        appConfig.codeName,
                        style: smallTextStyle(context),
                      ),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(CupertinoIcons.person),
                      title: Text(
                        S.of(context).developer,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            S.of(context).sheikhhaziq,
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
                      leading: const Icon(Icons.other_houses),
                      title: Text(
                        S.of(context).organisation,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            S.of(context).jhelumCorp,
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
                      leading: const Icon(Icons.telegram_outlined),
                      title: Text(
                        S.of(context).telegram,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://t.me/jhelumcorp'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(CupertinoIcons.person_3),
                      title: Text(
                        S.of(context).contributors,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/contributors'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(Icons.code),
                      title: Text(
                        S.of(context).sourceCode,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/jhelumcorp/gyawun'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(Icons.bug_report),
                      title: Text(
                        S.of(context).bugReport,
                        style: subtitleTextStyle(context),
                      ),
                      trailing: Icon(AdaptiveIcons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(
                              'https://github.com/jhelumcorp/gyawun/issues/new?assignees=&labels=bug&projects=&template=bug_report.yaml'),
                          mode: LaunchMode.externalApplication),
                    ),
                    AdaptiveListTile(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      leading: const Icon(Icons.request_page),
                      title: Text(
                        S.of(context).featureRequest,
                        style: subtitleTextStyle(context),
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
                        child: Text(S.of(context).madeInKashmir),
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
