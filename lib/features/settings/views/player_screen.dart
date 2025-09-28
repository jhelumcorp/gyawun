import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/providers/database_provider.dart';
import 'package:gyawun_music/features/settings/app_settings_identifiers.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.read(appSettingsProvider);
    final playerSettings = ref.watch(playerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Player")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: playerSettings.when(
          data: (settings) {
            return CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    SettingSwitchTile(
                      title: "Skip silence",
                      leading: Icon(Icons.fast_forward),
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
          },
          error: (e, s) => SizedBox(child: Text(e.toString())),
          loading: () => SizedBox.shrink(),
        ),
      ),
    );
  }
}
