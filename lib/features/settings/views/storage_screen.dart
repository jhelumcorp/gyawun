import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/storage/image_cache_manager.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Storage & backups")),

      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupTitle(title: "Storage"),
                  SettingTile(
                    title: "App Folder",
                    leading: const Icon(FluentIcons.folder_24_filled),
                    isFirst: true,
                    isLast: true,
                    subtitle: "/storage/emulated/0/Download",
                    trailing: IconButton.filled(
                      isSelected: false,
                      onPressed: () {},
                      icon: const Icon(Icons.change_circle_rounded),
                    ),
                  ),
                  const GroupTitle(title: "Cache"),
                  FutureBuilder(
                    future: CustomImageCacheManager.init(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return ValueListenableBuilder(
                        valueListenable: asyncSnapshot.data!,
                        builder: (context, value, child) {
                          return SettingTile(
                            isFirst: true,
                            title: "Image Cache",
                            leading: const Icon(FluentIcons.error_circle_24_filled),
                            subtitle: "${value.toStringAsFixed(2)} MB".toString(),
                            trailing: IconButton.filled(
                              onPressed: () async {
                                await CustomImageCacheManager.resetCache();
                              },
                              icon: const Icon(FluentIcons.delete_24_filled),
                              isSelected: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SettingTile(
                    isLast: true,
                    title: "Song Cache",
                    leading: Icon(FluentIcons.error_circle_24_filled),
                  ),
                  const GroupTitle(title: "Backup and restore"),
                  const SettingTile(
                    isFirst: true,
                    title: "Backup",
                    leading: Icon(Icons.backup_rounded),
                  ),
                  const SettingTile(
                    isLast: true,
                    title: "Restore",
                    leading: Icon(Icons.cloud_download_rounded),
                  ),
                  const BottomPlayingPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
