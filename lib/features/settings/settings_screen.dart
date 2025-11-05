import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyawun_music/features/settings/views/about_screen.dart';
import 'package:gyawun_music/features/settings/views/appearance_screen.dart';
import 'package:gyawun_music/features/settings/views/storage_screen.dart';
import 'package:gyawun_music/features/settings/views/player_screen.dart';
import 'package:gyawun_music/features/settings/views/privacy_screen.dart';
import 'package:gyawun_music/features/settings/views/youtube_music_screen.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupTitle(title: "General"),
                  SettingTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppearanceScreen(),
                        ),
                      );
                    },
                    isFirst: true,
                    title: "Appearance",
                    leading: Icon(FluentIcons.color_background_24_filled),
                  ),

                  SettingTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerScreen()),
                      );
                    },
                    isLast: true,
                    title: "Player",
                    leading: Icon(FluentIcons.play_24_filled),
                  ),
                  GroupTitle(title: "Services"),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YoutubeMusicScreen(),
                        ),
                      );
                    },
                  ),

                  GroupTitle(title: "Storage & Privacy"),

                  SettingTile(
                    title: "Storage and backups",
                    isFirst: true,
                    leading: Icon(FluentIcons.storage_24_filled),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StorageScreen(),
                        ),
                      );
                    },
                  ),

                  SettingTile(
                    title: "Privacy",
                    isLast: true,
                    leading: Icon(FluentIcons.shield_keyhole_24_filled),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyScreen(),
                        ),
                      );
                    },
                  ),

                  GroupTitle(title: "Updates & About"),

                  SettingTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutScreen()),
                      );
                    },
                    title: "About",
                    leading: Icon(FluentIcons.info_24_filled),
                    isFirst: true,
                  ),
                  SettingTile(
                    onTap: () {},
                    title: "Check for update",
                    leading: Icon(FluentIcons.arrow_circle_up_24_filled),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
