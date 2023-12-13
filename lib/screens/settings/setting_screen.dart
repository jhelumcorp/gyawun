import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/providers/theme_manager.dart';
import 'package:gyawun/screens/settings/data_lists.dart';

import 'package:gyawun/components/color_icon.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController searchController = TextEditingController();

  String searchText = "";
  @override
  void dispose() {
    super.dispose();
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
                fillColor: darkGreyColor.withAlpha(50),
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
                        child: const Icon(EvaIcons.close),
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
              onTap: showPaymentsModal,
            ),
          if (searchText == "") const Divider(),
          ...(searchText == ""
                  ? mainSettingDataList(context)
                  : allDataLists(context)
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
              leading: (e.color != null && e.icon != null)
                  ? ColorIcon(
                      color: e.color!,
                      icon: e.icon!,
                    )
                  : null,
              trailing: e.trailing != null
                  ? e.trailing!(context)
                  : (e.hasNavigation
                      ? Icon(
                          context.watch<ThemeManager>().isRightToLeftDirection
                              ? EvaIcons.chevronLeft
                              : EvaIcons.chevronRight,
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
                      e.subtitle!,
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

showPaymentsModal() {
  BuildContext context = GetIt.I<GlobalKey<NavigatorState>>().currentContext!;
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.background,
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: GetIt.I<ThemeManager>().isRightToLeftDirection
            ? TextDirection.rtl
            : TextDirection.ltr,
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
    ),
  );
}
