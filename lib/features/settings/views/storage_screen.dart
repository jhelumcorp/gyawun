import 'package:flutter/material.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';
import 'package:gyawun_music/services/storage/image_cache_manager.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  void initState() {
    super.initState();
    CustomImageCacheManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Storage")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupTitle(title: "Cache"),
              ValueListenableBuilder(
                valueListenable: CustomImageCacheManager.cacheSize,
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
              ),
              SettingTile(
                isLast: true,
                title: "Song Cache",
                leading: Icon(Icons.error),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
