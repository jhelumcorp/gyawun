import 'dart:io';

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:gyawun_beta/utils/bottom_modals.dart';
import 'package:gyawun_beta/ytmusic/ytmusic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import '../../generated/l10n.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import 'color_icon.dart';
import 'setting_screen_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController searchController = TextEditingController();
  bool? isBatteryOptimisationDisabled;

  String searchText = "";

  @override
  void initState() {
    super.initState();
    checkBatteryOptimisation();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  checkBatteryOptimisation() async {
    isBatteryOptimisationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).settings,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          AdaptiveIconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await GetIt.I<YTMusic>().getLibrarySubscriptions();
              })
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AdaptiveTextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  fillColor:
                      Platform.isWindows ? null : darkGreyColor.withAlpha(100),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  borderRadius:
                      BorderRadius.circular(Platform.isWindows ? 4.0 : 35),
                  hintText: S.of(context).searchSettings,
                  prefix: const Icon(Icons.search),
                  suffix: searchController.text.trim().isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            searchController.text = "";
                            searchText = "";
                            setState(() {});
                          },
                          child: const Icon(CupertinoIcons.clear),
                        )
                      : null,
                ),
              ),
              if (searchText == "" &&
                  isBatteryOptimisationDisabled != true &&
                  Platform.isAndroid)
                AdaptiveListTile(
                  backgroundColor: Colors.red.withOpacity(0.3),
                  leading: const ColorIcon(
                    icon: Icons.battery_alert,
                    color: Colors.red,
                  ),
                  title: const Text('Battery Optimisation Detected'),
                  subtitle: Text(
                    'Click here to disable battery optimisation.',
                    style: tinyTextStyle(context),
                  ),
                  onTap: () async {
                    await DisableBatteryOptimization
                        .showDisableBatteryOptimizationSettings();

                    await checkBatteryOptimisation();
                  },
                ),
              if (searchText == "")
                AdaptiveListTile(
                  leading:
                      ColorIcon(icon: Icons.money, color: Colors.accents[14]),
                  title: Text(
                    S.of(context).donate,
                    style:
                        textStyle(context, bold: false).copyWith(fontSize: 16),
                  ),
                  subtitle: Text(
                    S.of(context).donateSubtitle,
                    style: tinyTextStyle(context),
                  ),
                  onTap: () => showPaymentsModal(context),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ...(searchText == ""
                      ? settingScreenData(context)
                      : allSettingsData(context)
                          .where((element) => element.title
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList())
                  .map((e) {
                return AdaptiveListTile(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  title: Text(
                    e.title,
                    style:
                        textStyle(context, bold: false).copyWith(fontSize: 16),
                  ),
                  leading: (e.icon != null)
                      ? ColorIcon(
                          color: e.color,
                          icon: e.icon!,
                        )
                      : null,
                  trailing: e.trailing != null
                      ? e.trailing!(context)
                      : (e.hasNavigation
                          ? Icon(
                              AdaptiveIcons.chevron_right,
                              size: 30,
                            )
                          : null),
                  onTap: () {
                    if (e.hasNavigation && e.location != null) {
                      context.go(e.location!);
                    } else if (e.onTap != null) {
                      e.onTap!(context);
                    }
                  },
                  subtitle: e.subtitle != null ? e.subtitle!(context) : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

showPaymentsModal(BuildContext context) {
  Widget title = AdaptiveListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      S.of(context).paymentMethods,
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
          'Pay with UPI',
          style: subtitleTextStyle(context),
        ),
        onTap: () async {
          Navigator.pop(context);
          await launchUrl(
            Uri.parse(
                'upi://pay?cu=INR&pa=sheikhhaziq520@oksbi&pn=Gyawun&am=&tn=Gyawun'),
            mode: LaunchMode.externalApplication,
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
          S.of(context).supportMeOnKofi,
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
          S.of(context).buyMeACoffee,
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
  if (Platform.isWindows) {
    return fluent_ui.showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (context) => BottomModalLayout(title: title, child: child),
    );
  }
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BottomModalLayout(title: title, child: child),
  );
}
