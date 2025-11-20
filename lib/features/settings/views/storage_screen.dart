import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/services/storage/image_cache_manager.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.storageAndBackups)),

      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupTitle(title: "Storage", paddingTop: 0),
                  SettingTile(
                    title: loc.appFolder,
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
                            title: loc.imageCache,
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
                  SettingTile(
                    isLast: true,
                    title: loc.songCache,
                    leading: const Icon(FluentIcons.error_circle_24_filled),
                  ),
                  GroupTitle(title: loc.backupAndRestore),
                  SettingTile(
                    isFirst: true,
                    title: loc.backup,
                    leading: const Icon(Icons.backup_rounded),
                  ),
                  SettingTile(
                    isLast: true,
                    title: loc.restore,
                    leading: const Icon(Icons.cloud_download_rounded),
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
