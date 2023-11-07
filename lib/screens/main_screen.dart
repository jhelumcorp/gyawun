import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/components/bottom_player.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/screens/player_screen.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:titlebar_buttons/titlebar_buttons.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isLinux && Process.runSync("which", ["mpv"]).exitCode != 0) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("MPV not found"),
            content: const Text(
                "MPV is required to play music. Please install it and restart the app."),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () => exit(1),
                child:
                    const Text("Exit", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      }
    });
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
          if (Platform.isLinux)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                appWindow.startDragging();
              },
              child: WindowTitleBarBox(
                child: PreferredSize(
                    preferredSize:
                        Size(double.maxFinite, appWindow.titleBarHeight),
                    child: AppBar(
                      title: Text(S.of(context).gyawun),
                      centerTitle: true,
                      actions: [
                        DecoratedMinimizeButton(onPressed: appWindow.minimize),
                        DecoratedMaximizeButton(
                            onPressed: appWindow.maximizeOrRestore),
                        DecoratedCloseButton(onPressed: appWindow.close)
                      ],
                    )),
              ),
            ),
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
                          S.of(context).home,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Iconsax.music_playlist5),
                        icon: const Icon(Iconsax.music_playlist),
                        label: Text(
                          S.of(context).saved,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(EvaIcons.download),
                        icon: const Icon(EvaIcons.downloadOutline),
                        label: Text(
                          S.of(context).downloads,
                          style: smallTextStyle(context, bold: false),
                        ),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Iconsax.setting),
                        icon: const Icon(Iconsax.setting),
                        label: Text(
                          S.of(context).settings,
                          style: smallTextStyle(context, bold: false),
                        ),
                      )
                    ],
                    selectedIndex: widget.navigationShell.currentIndex,
                  ),
                Expanded(
                  child: widget.navigationShell,
                ),
                if (screenWidth >= 700 &&
                    MediaQuery.of(context).size.height >= 600 &&
                    context.watch<MediaManager>().currentSong != null)
                  SizedBox(
                      width: Platform.isLinux ? 450 : 350,
                      child: const PlayerScreen())
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
              selectedIndex: widget.navigationShell.currentIndex,
              destinations: [
                NavigationDestination(
                  selectedIcon: const Icon(EvaIcons.home),
                  icon: const Icon(EvaIcons.homeOutline),
                  label: S.of(context).home,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Iconsax.bookmark),
                  icon: const Icon(Iconsax.bookmark_2),
                  label: S.of(context).saved,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(EvaIcons.download),
                  icon: const Icon(EvaIcons.downloadOutline),
                  label: S.of(context).downloads,
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Iconsax.setting),
                  icon: const Icon(Iconsax.setting),
                  label: S.of(context).settings,
                )
              ],
              onDestinationSelected: _goBranch,
            )
          : null,
    );
  }
}
