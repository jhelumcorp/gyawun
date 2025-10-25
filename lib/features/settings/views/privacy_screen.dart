import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text("Privacy")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupTitle(title: "Playback"),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable playback history",
                leading: Icon(Icons.play_disabled),
                onChanged: (value) {},
              ),
              SettingTile(
                title: "Delete playback history",
                leading: Icon(Icons.playlist_remove),
                isLast: true,
              ),
              GroupTitle(title: "Search"),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable search history",
                leading: Icon(Icons.search_off),
                onChanged: (value) {},
              ),
              SettingTile(
                title: "Delete search history",
                leading: Icon(Icons.manage_search),
                isLast: true,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
