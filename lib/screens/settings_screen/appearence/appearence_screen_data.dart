import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../services/settings_manager.dart';
import '../../../themes/text_styles.dart';
import '../setting_item.dart';

List<SettingItem> appearenceScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).themeMode,
        icon: CupertinoIcons.moon,
        trailing: (context) {
          return DropdownButton<ThemeMode>(
              style: textStyle(context, bold: false).copyWith(fontSize: 16),
              underline: const SizedBox(),
              value: context.watch<SettingsManager>().themeMode,
              items: context
                  .read<SettingsManager>()
                  .themeModes
                  .map(
                    (e) => DropdownMenuItem(
                        value: e, child: Text(e.name.toUpperCase())),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                await context.read<SettingsManager>().setThemeMode(value);
              });
        },
      ),
      SettingItem(
        title: 'Dynamic Colors',
        icon: Icons.manage_history_sharp,
        onTap: (context) async {
          bool isEnabled = context.read<SettingsManager>().dynamicColors;
          context.read<SettingsManager>().dynamicColors = !isEnabled;
        },
        trailing: (context) {
          return CupertinoSwitch(
              value: context.watch<SettingsManager>().dynamicColors,
              onChanged: (val) async {
                context.read<SettingsManager>().dynamicColors = val;
              });
        },
      ),
    ];
List<ThemeMode> themeModes = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark
];
