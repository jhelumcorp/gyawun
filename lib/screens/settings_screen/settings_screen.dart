import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:gyawun/utils/check_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../../themes/text_styles.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../utils/bottom_modals.dart';
import 'color_icon.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? isBatteryOptimisationDisabled;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      checkBatteryOptimisation();
    }
  }

  Future<void> checkBatteryOptimisation() async {
    isBatteryOptimisationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).Settings,
            style: mediumTextStyle(context, bold: false)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            children: [
              if (isBatteryOptimisationDisabled != true && Platform.isAndroid)
                ListTile(
                  tileColor: Theme.of(context)
                      .colorScheme
                      .errorContainer
                      .withAlpha(200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  leading: const ColorIcon(
                    icon: Icons.battery_alert,
                    color: Colors.red,
                  ),
                  title: Text(
                    S.of(context).Battery_Optimisation_title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                  subtitle: Text(
                    S.of(context).Battery_Optimisation_message,
                    style: tinyTextStyle(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onErrorContainer
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  onTap: () async {
                    await Permission.ignoreBatteryOptimizations.request();
                    await checkBatteryOptimisation();
                  },
                ),
              GroupTitle(title: "General"),
              SettingTile(
                title: S.of(context).Appearence,
                leading: Icon(Icons.looks_rounded),
                isFirst: true,
                onTap: () {
                  context.go('/settings/appearence');
                },
              ),
              SettingTile(
                title: "Player",
                leading: Icon(Icons.play_arrow_rounded),
                isLast: true,
                onTap: () {
                  context.go('/settings/player');
                },
              ),
              GroupTitle(title: "Services"),
              SettingTile(
                title: "Youtube Music",
                leading: Icon(Icons.play_circle_fill),
                isFirst: true,
                isLast: true,
                onTap: () {
                  context.go('/settings/ytmusic');
                },
              ),
              GroupTitle(title: "Storage & Privacy"),
              SettingTile(
                title: "Backup and storage",
                leading: Icon(Icons.cloud_upload_rounded),
                isFirst: true,
                onTap: () {
                  context.go('/settings/backup_storage');
                },
              ),
              SettingTile(
                title: "Privacy",
                leading: Icon(Icons.privacy_tip),
                isLast: true,
                onTap: () {
                  context.go('/settings/privacy');
                },
              ),
              GroupTitle(title: "Updates & About"),
              SettingTile(
                title: S.of(context).About,
                leading: Icon(Icons.info_rounded),
                isFirst: true,
                onTap: () {
                  context.go('/settings/about');
                },
              ),
              SettingTile(
                title: S.of(context).Check_For_Update,
                leading: Icon(Icons.update_rounded),
                onTap: () {
                  Modals.showCenterLoadingModal(context);
                  checkUpdate().then((updateInfo) {
                    if (mounted) {
                      Navigator.pop(context);
                      Modals.showUpdateDialog(context, updateInfo);
                    }
                  });
                },
              ),
              SettingTile(
                leading: Icon(Icons.money),
                title: S.of(context).Donate,
                isLast: true,
                subtitle: S.of(context).Donate_Message,
                onTap: () => showPaymentsModal(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showPaymentsModal(BuildContext context) {
  Widget title = AdaptiveListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      S.of(context).Payment_Methods,
      style: mediumTextStyle(context),
    ),
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ColorIcon(color: Colors.accents[14], icon: Icons.money),
        ),
      ],
    ),
  );
  Widget child = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AdaptiveListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/images/upi.jpg', height: 30, width: 30)),
        title: Text(
          S.of(context).Pay_With_UPI,
          style: subtitleTextStyle(context),
        ),
        onTap: () async {
          Navigator.pop(context);
          await Clipboard.setData(
            const ClipboardData(text: 'sheikhhaziq76@okaxis'),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Copied UPI ID to clipboard!",
              ),
            ),
          );
        },
      ),
      AdaptiveListTile(
        leading: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(19, 195, 255, 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                Image.asset('assets/images/kofi.png', height: 30, width: 30)),
        title: Text(
          S.of(context).Support_Me_On_Kofi,
          style: subtitleTextStyle(context),
        ),
        onTap: () async {
          Navigator.pop(context);
          await launchUrl(
            Uri.parse('https://ko-fi.com/sheikhhaziq'),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
      AdaptiveListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child:
                Image.asset('assets/images/coffee.png', height: 30, width: 30)),
        title: Text(
          S.of(context).Buy_Me_A_Coffee,
          style: subtitleTextStyle(context),
        ),
        onTap: () async {
          Navigator.pop(context);
          await launchUrl(
            Uri.parse('https://buymeacoffee.com/sheikhhaziq'),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
    ],
  );

  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BottomModalLayout(title: title, child: child),
  );
}
