import 'package:flutter/material.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:gyawun/services/settings_manager.dart';
import 'package:gyawun/utils/bottom_modals.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';


class AppearenceScreen extends StatelessWidget {
  const AppearenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Appearence,),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            children: [
              GroupTitle(title: "Theme"),
              SettingTile(
                title: S.of(context).Theme_Mode,
                leading: Icon(Icons.dark_mode),
                // subtitle: context.watch<SettingsManager>().themeMode.name,
                isFirst: true,
                trailing: AdaptiveDropdownButton(
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
                    }),
              ),
              SettingTile(
                title: "AccentColor",
                leading: Icon(Icons.colorize_rounded),
                trailing: CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: [
                        Container(
                          color: context.watch<SettingsManager>().accentColor ??
                              Colors.black,
                          width: 20,
                        ),
                        Container(
                          color: context.watch<SettingsManager>().accentColor ??
                              Colors.white,
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () => Modals.showAccentSelector(context),
              ),
              SettingSwitchTile(
                title: 'Amoled Black',
                leading: Icon(Icons.mode_night_outlined),
                value: context.read<SettingsManager>().amoledBlack,
                onChanged: (value) {
                  context.read<SettingsManager>().amoledBlack = value;
                },
              ),
              SettingSwitchTile(
                title: S.of(context).Dynamic_Colors,
                leading: Icon(Icons.color_lens_outlined),
                isLast: true,
                value: context.watch<SettingsManager>().dynamicColors,
                onChanged: (value) {
                  context.read<SettingsManager>().dynamicColors = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
