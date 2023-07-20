import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/screens/settings/data_lists.dart';

import 'package:gyavun/components/color_icon.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';

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
        title: Text('Settings', style: mediumTextStyle(context, bold: false)),
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
                hintText: 'Search Settings',
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
          ...(searchText == ""
                  ? mainSettingDataList
                  : allDataLists
                      .where((element) => element.title
                          .toLowerCase()
                          .contains(searchText.toLowerCase()))
                      .toList())
              .map((e) {
            return ListTile(
              title: Text(
                e.title,
                style: textStyle(context).copyWith(fontSize: 16),
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
                      ? const Icon(
                          EvaIcons.chevronRight,
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
