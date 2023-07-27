import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/components/color_icon.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/screens/settings/data_lists.dart';
import 'package:gyawun/ui/text_styles.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theme,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ...themesSettingDataList(context).map((e) {
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

List<ThemeMode> dropdownItems = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark
];
