import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/storage/image_cache_manager.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    CustomImageCacheManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GroupTitle(title: "Playback"),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable playback history",
                leading: const Icon(Icons.play_disabled_rounded),
                onChanged: (value) {},
              ),
              const SettingTile(
                title: "Delete playback history",
                leading: Icon(FluentIcons.history_dismiss_24_filled),
                isLast: true,
              ),
              const GroupTitle(title: "Search"),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable search history",
                leading: const Icon(Icons.search_off_rounded),
                onChanged: (value) {},
              ),
              const SettingTile(
                title: "Delete search history",
                leading: Icon(Icons.manage_search_rounded),
                isLast: true,
              ),
              const BottomPlayingPadding(),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
