import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/settings/views/appearance_screen.dart';
import 'package:yaru/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              leading: Navigator.of(context).canPop() ? YaruBackButton() : null,
              title: Text("Settings"),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Settings"),
                titlePadding: EdgeInsets.all(16),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                SettingTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppearanceScreen(),
                      ),
                    );
                  },
                  title: "Appearance",
                  leading: Icons.color_lens_outlined,
                ),
                SettingTile(
                  onTap: () {},
                  title: "Content",
                  leading: Icons.language_rounded,

                  // trailing: Icon(Icons.chevron_right, size: 26),
                ),
                SettingTile(
                  onTap: () {},
                  title: "Player and audio",
                  leading: Icons.play_arrow_outlined,

                  // trailing: Icon(Icons.chevron_right, size: 26),
                ),
                SettingTile(
                  onTap: () {},
                  title: "Backup & Restore",
                  leading: Icons.settings_backup_restore_rounded,

                  // trailing: Icon(Icons.chevron_right, size: 26),
                ),

                SettingTile(
                  onTap: () {},
                  title: "About",
                  leading: Icons.info_outline_rounded,

                  // trailing: Icon(Icons.chevron_right, size: 26),
                ),
                SettingTile(
                  onTap: () {},
                  title: "Check for update",
                  leading: Icons.update_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final IconData leading;
  final IconData? trailingicon;
  final void Function()? onTap;
  const SettingTile({
    super.key,
    required this.title,
    required this.leading,
    this.trailingicon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(leading, size: 26),
      trailing: trailingicon != null ? Icon(trailingicon, size: 26) : null,
    );
  }
}
