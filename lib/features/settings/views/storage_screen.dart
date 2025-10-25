import 'package:flutter/material.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/storage/image_cache_manager.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Storage & backups")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupTitle(title: "Storage"),
                  SettingTile(
                    title: "App Folder",
                    leading: Icon(Icons.folder_rounded),
                    isFirst: true,
                    isLast: true,
                    subtitle: "/storage/emulated/0/Download",
                    trailing: IconButton.filled(isSelected: false,onPressed: (){}, icon: Icon(Icons.change_circle_rounded)),
                  ),
                  GroupTitle(title: "Cache"),
                  FutureBuilder(
                    future:  CustomImageCacheManager.init(),
                    builder: (context, asyncSnapshot) {
                      if(!asyncSnapshot.hasData || asyncSnapshot.data==null){
                        return SizedBox.shrink();
                      }
                      return ValueListenableBuilder(
                        valueListenable:asyncSnapshot.data!,
                        builder: (context, value, child) {
                          return SettingTile(
                            isFirst: true,
                            title: "Image Cache",
                            leading: Icon(Icons.error),
                            subtitle: "${value.toStringAsFixed(2)} MB".toString(),
                            trailing: IconButton.filled(
                              onPressed: () async {
                                await CustomImageCacheManager.resetCache();
                              },
                              icon: Icon(Icons.delete),
                              isSelected: false,
                            ),
                          );
                        },
                      );
                    }
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Song Cache",
                    leading: Icon(Icons.error),
                  ),
                  GroupTitle(title: "Backup and restore"),
                  SettingTile(
                    isFirst: true,
                    title: "Backup",
                    leading: Icon(Icons.backup),
                  ),
                  SettingTile(
                    isLast: true,
                    title: "Restore",
                    leading: Icon(Icons.cloud_download),
                  ),
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
