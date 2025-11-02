import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';

import '../widgets/setting_tile.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = sl<AppSettings>();
    return Scaffold(
      appBar: AppBar(title: Text("Player")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: StreamBuilder(stream: appSettings.player(), builder:(context, snapshot) {
           if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
          if(snapshot.hasData && snapshot.data!=null){
            final settings = snapshot.data!;
            return  CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    SettingSwitchTile(
                      title: "Skip silence",
                      leading: Icon(FluentIcons.fast_forward_24_filled),
                      isFirst: true,
                      isLast: true,
                      value: settings.skipSilence,

                      onChanged: (value) async {
                        await appSettings.setBool(
                          AppSettingsIdentifiers.skipSilence,
                          value,
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          }
          return SizedBox();
        },)
      ),
    );
  }
}
