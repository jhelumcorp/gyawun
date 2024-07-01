import 'dart:isolate';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_beta/utils/pprint.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../generated/l10n.dart';
import '../../themes/text_styles.dart';
import '../../utils/bottom_modals.dart';
import '../../utils/check_update.dart';
import 'bottom_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('MainScreen'));
  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
    UpdateInfo? updateInfo = await Isolate.run(() async {
      return await checkUpdate(deviceInfo: deviceInfo);
    });

    if (updateInfo != null) {
      if (mounted) {
        Modals.showUpdateDialog(context, updateInfo);
      }
    }
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
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
                    extended: (screenWidth > 1000),
                    onDestinationSelected: _goBranch,
                    destinations: [
                      NavigationRailDestination(
                        selectedIcon:
                            const Icon(CupertinoIcons.music_house_fill),
                        icon: const Icon(CupertinoIcons.music_house),
                        label: Text(
                          S.of(context).home,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.library_music_outlined),
                        icon: const Icon(Icons.library_music_outlined),
                        label: Text(
                          S.of(context).saved,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon:
                            const Icon(CupertinoIcons.square_arrow_down_fill),
                        icon: const Icon(CupertinoIcons.square_arrow_down),
                        label: Text(
                          S.of(context).downloads,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(CupertinoIcons.gear_alt_fill),
                        icon: const Icon(CupertinoIcons.gear_alt),
                        label: Text(
                          S.of(context).settings,
                          style: smallTextStyle(context, bold: false),
                        ),
                      )
                    ],
                    selectedIndex: widget.navigationShell.currentIndex,
                  ),
                if (screenWidth >= 450) const VerticalDivider(width: 2),
                Expanded(
                  child: widget.navigationShell,
                ),
                // if (screenWidth >= 700 &&
                //     MediaQuery.of(context).size.height >= 600 &&
                //     context.watch<MediaManager>().currentSong != null)
                //   SizedBox(
                //       width: Platform.isLinux ? 450 : 350,
                //       child: const PlayerScreen())
              ],
            ),
          ),
          const BottomPlayer()
        ],
      ),
      bottomNavigationBar: screenWidth < 450
          ? SalomonBottomBar(
              currentIndex: widget.navigationShell.currentIndex,
              items: [
                SalomonBottomBarItem(
                  activeIcon: const Icon(CupertinoIcons.music_house_fill),
                  icon: const Icon(CupertinoIcons.music_house),
                  title: Text(S.of(context).home),
                ),
                SalomonBottomBarItem(
                  activeIcon: const Icon(Icons.library_music),
                  icon: const Icon(Icons.library_music_outlined),
                  title: Text(S.of(context).saved),
                ),
                SalomonBottomBarItem(
                  activeIcon: const Icon(CupertinoIcons.square_arrow_down_fill),
                  icon: const Icon(CupertinoIcons.square_arrow_down),
                  title: Text(S.of(context).downloads),
                ),
                SalomonBottomBarItem(
                  activeIcon: const Icon(CupertinoIcons.settings_solid),
                  icon: const Icon(CupertinoIcons.settings),
                  title: Text(S.of(context).settings),
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.surface,
              onTap: _goBranch,
            )
          : null,
    );
  }
}
