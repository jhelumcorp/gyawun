import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.privacy)),

      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GroupTitle(title: "Playback", paddingTop: 0),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable Playback History",
                leading: const Icon(Icons.play_disabled_rounded),
                onChanged: (value) {},
              ),
              const SettingTile(
                title: "Delete Playback History",
                leading: Icon(FluentIcons.history_dismiss_24_filled),
                isLast: true,
              ),
              GroupTitle(title: loc.search),
              SettingSwitchTile(
                value: false,
                isFirst: true,
                title: "Disable Search History",
                leading: const Icon(Icons.search_off_rounded),
                onChanged: (value) {},
              ),
              const SettingTile(
                title: "Delete Search History",
                leading: Icon(Icons.manage_search_rounded),
                isLast: true,
              ),
              const BottomPlayingPadding(),
            ],
          ),
        ),
      ),
    );
  }
}
