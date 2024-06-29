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
                context.read<SettingsManager>().themeMode = value;
              });
        },
      ),
      SettingItem(
        title: S.of(context).materialColors,
        icon: Icons.manage_history_sharp,
        onTap: (context) async {
          bool isEnabled = context.read<SettingsManager>().materialColors;
          context.read<SettingsManager>().materialColors = !isEnabled;
        },
        trailing: (context) {
          return CupertinoSwitch(
              value: context.watch<SettingsManager>().materialColors,
              onChanged: (val) async {
                context.read<SettingsManager>().materialColors = val;
              });
        },
      ),
    ];
List<ThemeMode> themeModes = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark
];
