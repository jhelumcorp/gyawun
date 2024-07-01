import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_beta/utils/bottom_modals.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String searchText = "";
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
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
              decoration: InputDecoration(
                fillColor: darkGreyColor.withAlpha(100),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide.none,
                ),
                hintText: S.of(context).searchSettings,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.trim().isNotEmpty
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
          ),
          if (searchText == "")
            ListTile(
              leading: ColorIcon(icon: Icons.money, color: Colors.accents[14]),
              title: Text(
                S.of(context).donate,
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
              ),
              subtitle: Text(
                S.of(context).donateSubtitle,
                style: tinyTextStyle(context),
              ),
              onTap: () => showPaymentsModal(context),
            ),
          if (searchText == "") const Divider(),
          ...(searchText == ""
                  ? settingScreenData(context)
                  : allSettingsData(context)
                      .where((element) => element.title
                          .toLowerCase()
                          .contains(searchText.toLowerCase()))
                      .toList())
              .map((e) {
            return ListTile(
              title: Text(
                e.title,
                style: textStyle(context, bold: false).copyWith(fontSize: 16),
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
                      ? const Icon(
                          CupertinoIcons.chevron_right,
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
              subtitle: e.subtitle != null
                  ? Text(
                      e.subtitle!(context),
                      style: tinyTextStyle(context),
                      maxLines: 2,
                    )
                  : null,
            );
          }),
        ],
      ),
    );
  }
}

showPaymentsModal(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => BottomModalLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
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
                  child:
                      ColorIcon(color: Colors.accents[14], icon: Icons.money),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/images/upi.jpg',
                    height: 30, width: 30)),
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
          ListTile(
            leading: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(19, 195, 255, 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset('assets/images/kofi.png',
                    height: 30, width: 30)),
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
          ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/images/coffee.png',
                    height: 30, width: 30)),
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
      ),
    ),
  );
}
