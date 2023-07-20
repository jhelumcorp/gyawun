import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/components/bottom_player.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/screens/player_screen.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (screenWidth >= 450)
                  NavigationRail(
                    labelType: NavigationRailLabelType.none,
                    selectedLabelTextStyle: smallTextStyle(context, bold: true),
                    extended: screenWidth > 1000,
                    onDestinationSelected: _goBranch,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(EvaIcons.homeOutline),
                        label: Text(
                          'Home',
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Iconsax.music_playlist5),
                        icon: const Icon(Iconsax.music_playlist),
                        label: Text(
                          'Playlists',
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(EvaIcons.download),
                        icon: const Icon(EvaIcons.downloadOutline),
                        label: Text(
                          'Downloads',
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Iconsax.setting),
                        icon: const Icon(Iconsax.setting),
                        label: Text(
                          'Settings',
                          style: smallTextStyle(context, bold: false),
                        ),
                      )
                    ],
                    selectedIndex: navigationShell.currentIndex,
                  ),
                Expanded(
                  child: navigationShell,
                ),
                if (screenWidth >= 700 &&
                    MediaQuery.of(context).size.height >= 600 &&
                    context.watch<MediaManager>().currentSong != null)
                  const SizedBox(width: 350, child: PlayerScreen())
              ],
            ),
          ),
          const BottomPlayer()
        ],
      ),
      bottomNavigationBar: screenWidth < 450
          ? NavigationBar(
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: navigationShell.currentIndex,
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(EvaIcons.home),
                  icon: Icon(EvaIcons.homeOutline),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Iconsax.music_playlist5),
                  icon: Icon(Iconsax.music_playlist),
                  label: 'Playlists',
                ),
                NavigationDestination(
                  selectedIcon: Icon(EvaIcons.download),
                  icon: Icon(EvaIcons.downloadOutline),
                  label: 'Downloads',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Iconsax.setting),
                  icon: Icon(Iconsax.setting),
                  label: 'Settings',
                )
              ],
              onDestinationSelected: _goBranch,
            )
          : null,
    );
  }
}
