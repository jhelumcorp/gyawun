import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/screens/settings_screen/setting_item.dart';
import 'package:gyawun/services/media_player.dart';
import 'package:gyawun/services/settings_manager.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';


class PlayerSettingsScreen extends StatelessWidget {
  const PlayerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            children: [
              SettingTile(
          title: S.of(context).Loudness_And_Equalizer,
          leading: Icon(Icons.equalizer_outlined),
          isFirst: true,
          isLast: !Platform.isAndroid,
          onTap: (){
            context.go('/settings/player/equalizer');
          },
        ),
        if (!Platform.isWindows)
        SettingSwitchTile(
          title: S.of(context).Skip_Silence,
          leading: Icon(Icons.fast_forward),
          value: context.watch<SettingsManager>().skipSilence,
          onChanged: (value) async {
            await GetIt.I<MediaPlayer>()
                .skipSilence(value);
          },
          isFirst: !Platform.isAndroid,
          isLast: true,
        ),
             
            ],
          ),
        ),
      ),
    );
  }
}
