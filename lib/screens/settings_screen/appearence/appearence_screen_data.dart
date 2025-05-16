import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import '../../../services/settings_manager.dart';
import '../../../utils/bottom_modals.dart';
import '../setting_item.dart';

List<SettingItem> appearenceScreenData(BuildContext context) => [
      SettingItem(
        title: S.of(context).Theme_Mode,
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
      SettingItem(
        title: 'Accent Color',
        icon: Icons.colorize_outlined,
        trailing: (context) {
          Color? accentColor = context.watch<SettingsManager>().accentColor;
          return CircleAvatar(
            radius: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Container(
                    color: accentColor ?? Colors.black,
                    width: 20,
                  ),
                  Container(
                    color: accentColor ?? Colors.white,
                    width: 20,
                  )
                ],
              ),
            ),
          );
        },
        onTap: (context) {
          Modals.showAccentSelector(context);
        },
      ),
      if (Platform.isWindows || Platform.isLinux)
        SettingItem(
          title: S.of(context).Window_Effect,
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
        title: 'Amoled Black',
        icon: Icons.mode_night_outlined,
        onTap: (context) async {
          bool isEnabled = context.read<SettingsManager>().amoledBlack;
          context.read<SettingsManager>().amoledBlack = !isEnabled;
        },
        trailing: (context) {
          return AdaptiveSwitch(
              value: context.watch<SettingsManager>().amoledBlack,
              onChanged: (val) async {
                context.read<SettingsManager>().amoledBlack = val;
              });
        },
      ),
      SettingItem(
        title: S.of(context).Dynamic_Colors,
        icon: Icons.color_lens_outlined,
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
