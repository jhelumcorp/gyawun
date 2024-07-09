import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/dropdown_button.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/switch.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import '../../../generated/l10n.dart';
import '../../../services/settings_manager.dart';
import '../setting_item.dart';

List<SettingItem> appearenceScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).themeMode,
        icon: CupertinoIcons.moon,
        trailing: (context) {
          return AdaptiveDropdownButton(
              value: context.watch<SettingsManager>().themeMode,
              items: context
                  .read<SettingsManager>()
                  .themeModes
                  .map(
                    (e) => AdaptiveDropdownMenuItem(
                        value: e, child: Text(e.name.toUpperCase())),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                await context.read<SettingsManager>().setThemeMode(value);
              });
        },
      ),
      if (Platform.isWindows)
        SettingItem(
          title: 'Window Effect',
          icon: fluent_ui.FluentIcons.background_color,
          trailing: (context) {
            return AdaptiveDropdownButton(
                value: context.watch<SettingsManager>().windowEffect,
                items: context
                    .read<SettingsManager>()
                    .windowEffectList
                    .map(
                      (e) => AdaptiveDropdownMenuItem(
                          value: e, child: Text(e.name.toUpperCase())),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) return;
                  await context.read<SettingsManager>().setwindowEffect(value);
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
          return AdaptiveSwitch(
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
