import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/HomeScreen.dart';
import 'package:vibe_music/screens/PlayListScreen.dart';
import 'package:vibe_music/screens/PlayerScreen.dart';
import 'package:vibe_music/screens/SearchScreen.dart';
import 'package:vibe_music/screens/SettingsScreen.dart';
import 'package:vibe_music/widgets/PanelHeader.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;
  final _homeNavigatorKey = GlobalKey<NavigatorState>();
  final _searchNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    HomeApi.setCountry();
  }

  @override
  void dispose() {
    context.read<MusicPlayer>().player.stop();
    context.read<MusicPlayer>().player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: ((value) {
                    MiniplayerController miniplayerController =
                        context.read<MusicPlayer>().miniplayerController;
                    miniplayerController.animateToHeight(state: PanelState.MIN);
                    setState(() {
                      _pageIndex = value;
                    });
                  }),
                  children: [
                    HomeTab(
                      navigatorKey: _homeNavigatorKey,
                    ),
                    SearchTab(
                      navigatorKey: _searchNavigatorKey,
                    ),
                    const SettingsScreen(),
                  ],
                );
              }),
            ),
            if (context.watch<MusicPlayer>().isInitialized &&
                context.watch<MusicPlayer>().song != null)
              Miniplayer(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  controller: context.watch<MusicPlayer>().miniplayerController,
                  minHeight: 70,
                  maxHeight: constraints.maxHeight,
                  // maxHeight: size.height - 80,
                  builder: (height, percentage) {
                    return Stack(
                      children: [
                        Opacity(
                          opacity: percentage,
                          child: PlayerScreen(
                            height: height,
                            percentage: percentage,
                          ),
                        ),
                        Opacity(
                            opacity: 1 - (percentage),
                            child: const PanelHeader()),
                      ],
                    );
                  }),
          ],
        );
      }),
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: S.of(context).Home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search_rounded),
            label: S.of(context).Search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
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
                      ));
            default:
              return MaterialPageRoute(builder: (_) => const Text("data"));
          }
        },
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({
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
              return MaterialPageRoute(builder: (_) => const SearchScreen());
            case '/search/playlist':
              Map<String, dynamic> args =
                  settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                  builder: (_) => PlayListScreen(
                        playlistId: args['playlistId'],
                      ));
            default:
              return MaterialPageRoute(builder: (_) => const Text("data"));
          }
        },
      ),
    );
  }
}
