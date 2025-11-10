import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupTitle(title: "General"),
                  SettingTile(
                    onTap: () {
                      context.push("/settings/appearance");
                    },
                    isFirst: true,
                    title: "Appearance",
                    leading: const Icon(FluentIcons.color_background_24_filled),
                  ),

                  SettingTile(
                    onTap: () {
                      context.push("/settings/player");
                    },
                    isLast: true,
                    title: "Player",
                    leading: const Icon(FluentIcons.play_24_filled),
                  ),
                  const GroupTitle(title: "Services"),

                  SettingTile(
                    title: "Youtube Music",
                    leading: SvgPicture.asset(
                      'assets/svgs/youtube_music.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurfaceVariant,
                        BlendMode.srcIn,
                      ),
                    ),
                    isFirst: true,
                    isLast: true,
                    onTap: () {
                      context.push("/settings/ytmusic");
                    },
                  ),

                  const GroupTitle(title: "Storage & Privacy"),

                  SettingTile(
                    title: "Storage and backups",
                    isFirst: true,
                    leading: const Icon(FluentIcons.storage_24_filled),
                    onTap: () {
                      context.push("/settings/storage");
                    },
                  ),

                  SettingTile(
                    title: "Privacy",
                    isLast: true,
                    leading: const Icon(FluentIcons.shield_keyhole_24_filled),
                    onTap: () {
                      context.push("/settings/privacy");
                    },
                  ),

                  const GroupTitle(title: "Updates & About"),

                  SettingTile(
                    onTap: () {
                      context.push("/settings/about");
                    },
                    title: "About",
                    leading: const Icon(FluentIcons.info_24_filled),
                    isFirst: true,
                  ),
                  SettingTile(
                    onTap: () {},
                    title: "Check for update",
                    leading: const Icon(FluentIcons.arrow_circle_up_24_filled),
                    isLast: true,
                  ),
                  const BottomPlayingPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
