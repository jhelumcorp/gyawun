import 'package:flutter/material.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:gyawun/services/settings_manager.dart';
import 'package:gyawun/utils/bottom_modals.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';


class AppearenceScreen extends StatelessWidget {
  const AppearenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).Appearence,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
              // ...appearenceScreenData(context).map((e) {
              //   return Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 4),
              //     child: AdaptiveListTile(
              //       title: Text(
              //         e.title,
              //         style: textStyle(context, bold: false)
              //             .copyWith(fontSize: 16),
              //       ),
              //       leading: (e.icon != null)
              //           ? ColorIcon(
              //               color: e.color,
              //               icon: e.icon!,
              //             )
              //           : null,
              //       trailing: e.trailing != null
              //           ? e.trailing!(context)
              //           : (e.hasNavigation
              //               ? Icon(
              //                   AdaptiveIcons.chevron_right,
              //                   size: 30,
              //                 )
              //               : null),
              //       onTap: (e.hasNavigation && e.location != null) ||
              //               e.onTap != null
              //           ? () {
              //               if (e.hasNavigation && e.location != null) {
              //                 context.go(e.location!);
              //               } else if (e.onTap != null) {
              //                 e.onTap!(context);
              //               }
              //             }
              //           : null,
              //       subtitle: e.subtitle != null ? e.subtitle!(context) : null,
              //     ),
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
