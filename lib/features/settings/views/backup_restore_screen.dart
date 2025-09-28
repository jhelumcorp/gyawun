import 'package:flutter/material.dart';
import 'package:gyawun_music/features/settings/widgets/setting_tile.dart';

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backup and restore")),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
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
