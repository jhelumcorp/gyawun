import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/ArtistScreen.dart';
import 'package:vibe_music/screens/DownloadScreen.dart';
import 'package:vibe_music/screens/FavouriteScreen.dart';
import 'package:vibe_music/screens/HomeScreen.dart';
import 'package:vibe_music/screens/PlayListScreen.dart';
import 'package:vibe_music/screens/PlayerScreen.dart';
import 'package:vibe_music/screens/SearchScreen.dart';
import 'package:vibe_music/screens/SettingsScreen.dart';
import 'package:vibe_music/widgets/PanelHeader.dart';

import '../utils/checkUpdate.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;
  final _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    checkUpdate().then((details) {
      if (details['isUpdate']) {
        showUpdate(context, details['url']);
      }
    });
  }

  @override
  void dispose() {
    context.read<MusicPlayer>().player.stop();
    context.read<MusicPlayer>().player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, child) {
          bool darkTheme = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            body: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      return PageView(
                        controller: _pageController,
                        onPageChanged: ((value) {
                          MiniplayerController miniplayerController =
                              context.read<MusicPlayer>().miniplayerController;
                          miniplayerController.animateToHeight(
                              state: PanelState.MIN);
                          setState(() {
                            _pageIndex = value;
                          });
                        }),
                        children: [
                          Directionality(
                            textDirection:
                                box.get('textDirection', defaultValue: 'ltr') ==
                                        'rtl'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            child: HomeTab(
                              navigatorKey: _homeNavigatorKey,
                            ),
                          ),
                          Directionality(
                            textDirection:
                                box.get('textDirection', defaultValue: 'ltr') ==
                                        'rtl'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            child: const FavouriteScreen(),
                          ),
                          Directionality(
                            textDirection:
                                box.get('textDirection', defaultValue: 'ltr') ==
                                        'rtl'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            child: const DownloadScreen(),
                          ),
                        ],
                      );
                    }),
                  ),
                  if (context.watch<MusicPlayer>().isInitialized &&
                      context.watch<MusicPlayer>().song != null)
                    Miniplayer(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        controller:
                            context.watch<MusicPlayer>().miniplayerController,
                        minHeight: 70,
                        maxHeight: constraints.maxHeight,
                        builder: (height, percentage) {
                          return Stack(
                            children: [
                              Opacity(
                                opacity: percentage,
                                child: const PlayerScreen(),
                              ),
                              Opacity(
                                  opacity: 1 - (percentage),
                                  child: PanelHeader(
                                    song: context.watch<MusicPlayer>().song!,
                                  )),
                            ],
                          );
                        }),
                ],
              );
            }),
            bottomNavigationBar: NavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              height: 60,
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: darkTheme ? Colors.white : Colors.black,
                  ),
                  selectedIcon: Icon(
                    Icons.home_rounded,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  label: S.of(context).Home,
                ),
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.heart,
                    color: darkTheme ? Colors.white : Colors.black,
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.heart_fill,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  label: S.of(context).Settings,
                ),
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.download_circle,
                    color: darkTheme ? Colors.white : Colors.black,
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.download_circle_fill,
                    color: darkTheme ? Colors.black : Colors.white,
                  ),
                  label: S.of(context).Settings,
                ),
              ],
              onDestinationSelected: (int index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              selectedIndex: _pageIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            ),
          );
        });
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _navigatorKey = navigatorKey,
        super(key: key);

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState!.canPop() &&
            _navigatorKey.currentState != null) {
          _navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/playlist':
              Map<String, dynamic> args =
                  settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                  builder: (_) => PlayListScreen(
                        playlistId: args['playlistId'],
                        isAlbum: args['isAlbum'] ?? false,
                      ));
            case '/home/artist':
              Map<String, dynamic> args =
                  settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                  builder: (_) => ArtistScreen(
                        browseId: args['browseId'],
                        imageUrl: args['imageUrl'],
                        name: args['name'],
                      ));
            default:
              return MaterialPageRoute(builder: (_) => const Text("data"));
          }
        },
      ),
    );
  }
}
