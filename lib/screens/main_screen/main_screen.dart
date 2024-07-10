import 'dart:io';
import 'dart:isolate';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_beta/services/yt_account.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:window_manager/window_manager.dart';

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

class _MainScreenState extends State<MainScreen> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();

    _update();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
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
  void onWindowClose() async {
    windowManager.destroy();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable: GetIt.I<YTAccount>().isLogged,
        builder: (context, isLogged, child) {
          return Platform.isWindows
              ? _buildWindowsMain(
                  _goBranch,
                  widget.navigationShell,
                  isLogged: isLogged,
                )
              : Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (screenWidth >= 450)
                              NavigationRail(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                labelType: NavigationRailLabelType.none,
                                selectedLabelTextStyle:
                                    smallTextStyle(context, bold: true),
                                extended: (screenWidth > 1000),
                                onDestinationSelected: (index) {
                                  int currentIndex = isLogged
                                      ? index
                                      : index >= 2
                                          ? index + 1
                                          : index;
                                  _goBranch(currentIndex);
                                },
                                destinations: [
                                  NavigationRailDestination(
                                    selectedIcon: const Icon(
                                        CupertinoIcons.music_house_fill),
                                    icon:
                                        const Icon(CupertinoIcons.music_house),
                                    label: Text(
                                      S.of(context).home,
                                      style:
                                          smallTextStyle(context, bold: false),
                                    ),
                                  ),
                                  NavigationRailDestination(
                                    selectedIcon: const Icon(
                                        Icons.library_music_outlined),
                                    icon: const Icon(
                                        Icons.library_music_outlined),
                                    label: Text(
                                      S.of(context).saved,
                                      style:
                                          smallTextStyle(context, bold: false),
                                    ),
                                  ),
                                  if (isLogged)
                                    NavigationRailDestination(
                                      selectedIcon: const Icon(
                                          CupertinoIcons.music_note_2),
                                      icon:
                                          const Icon(CupertinoIcons.music_note),
                                      label: Text(
                                        'YTMusic',
                                        style: smallTextStyle(context,
                                            bold: false),
                                      ),
                                    ),
                                  NavigationRailDestination(
                                    selectedIcon: const Icon(
                                        CupertinoIcons.gear_alt_fill),
                                    icon: const Icon(CupertinoIcons.gear_alt),
                                    label: Text(
                                      S.of(context).settings,
                                      style:
                                          smallTextStyle(context, bold: false),
                                    ),
                                  )
                                ],
                                selectedIndex: isLogged
                                    ? widget.navigationShell.currentIndex
                                    : widget.navigationShell.currentIndex >= 2
                                        ? widget.navigationShell.currentIndex -
                                            1
                                        : widget.navigationShell.currentIndex,
                              ),
                            Expanded(
                              child: widget.navigationShell,
                            ),
                            // if (screenWidth >= 700 &&
                            //     MediaQuery.of(context).size.height >= 600 &&
                            //     context.watch<MediaPlayer>().currentSongNotifier.value !=
                            //         null)
                            //   SizedBox(
                            //       width: Platform.isWindows ? 450 : 350,
                            //       child: const PlayerScreen())
                          ],
                        ),
                      ),
                      const BottomPlayer()
                    ],
                  ),
                  bottomNavigationBar: screenWidth < 450
                      ? SalomonBottomBar(
                          currentIndex: isLogged
                              ? widget.navigationShell.currentIndex
                              : widget.navigationShell.currentIndex >= 2
                                  ? widget.navigationShell.currentIndex - 1
                                  : widget.navigationShell.currentIndex,
                          items: [
                            SalomonBottomBarItem(
                              activeIcon:
                                  const Icon(CupertinoIcons.music_house_fill),
                              icon: const Icon(CupertinoIcons.music_house),
                              title: Text(S.of(context).home),
                            ),
                            SalomonBottomBarItem(
                              activeIcon: const Icon(Icons.library_music),
                              icon: const Icon(Icons.library_music_outlined),
                              title: Text(S.of(context).saved),
                            ),
                            if (isLogged)
                              SalomonBottomBarItem(
                                activeIcon:
                                    const Icon(CupertinoIcons.music_note_2),
                                icon: const Icon(CupertinoIcons.music_note),
                                title: const Text('YTMusic'),
                              ),
                            SalomonBottomBarItem(
                              activeIcon:
                                  const Icon(CupertinoIcons.settings_solid),
                              icon: const Icon(CupertinoIcons.settings),
                              title: Text(S.of(context).settings),
                            )
                          ],
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          onTap: (index) {
                            int currentIndex = isLogged
                                ? index
                                : index >= 2
                                    ? index + 1
                                    : index;
                            _goBranch(currentIndex);
                          },
                        )
                      : null,
                );
        });
  }

  _buildWindowsMain(
    Function goTOBranch,
    StatefulNavigationShell navigationShell, {
    bool isLogged = false,
  }) {
    return fluent_ui.NavigationView(
      appBar: fluent_ui.NavigationAppBar(
        title: const DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text('Gyawun'),
          ),
        ),
        leading: fluent_ui.Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Image.asset(
            'assets/images/icon.png',
            height: 25,
            width: 25,
          ),
        ),
        actions: const WindowButtons(),
      ),
      paneBodyBuilder: (item, body) {
        return Column(
          children: [
            fluent_ui.Expanded(child: navigationShell),
            const BottomPlayer()
          ],
        );
      },
      pane: fluent_ui.NavigationPane(
          selected: isLogged
              ? widget.navigationShell.currentIndex
              : widget.navigationShell.currentIndex >= 2
                  ? widget.navigationShell.currentIndex - 1
                  : widget.navigationShell.currentIndex,
          items: [
            fluent_ui.PaneItem(
              key: const ValueKey('/'),
              icon: const Icon(fluent_ui.FluentIcons.home),
              title: Text(S.of(context).home),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(0),
            ),
            fluent_ui.PaneItem(
              key: const ValueKey('/saved'),
              icon: const Icon(fluent_ui.FluentIcons.library),
              title: Text(S.of(context).saved),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(1),
            ),
            if (isLogged)
              fluent_ui.PaneItem(
                key: const ValueKey('/ytmusic'),
                icon: const Icon(fluent_ui.FluentIcons.music_note),
                title: const Text('YTMusic'),
                body: const SizedBox.shrink(),
                onTap: () => goTOBranch(2),
              ),
          ],
          footerItems: [
            fluent_ui.PaneItem(
              key: const ValueKey('/settings'),
              icon: const Icon(fluent_ui.FluentIcons.settings),
              title: const Text('Settings'),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(3),
            )
          ]),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final fluent_ui.FluentThemeData theme = fluent_ui.FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
