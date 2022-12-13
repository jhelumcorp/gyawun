import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/HomeScreen.dart';
import 'package:vibe_music/screens/PlayListScreen.dart';
import 'package:vibe_music/screens/PlayerScreen.dart';
import 'package:vibe_music/screens/SearchScreen.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:vibe_music/widgets/PanelHeader.dart';
import 'package:we_slide/we_slide.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WeSlideController queueController = WeSlideController();
  WeSlideController weSlideController = WeSlideController();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
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
      // backgroundColor: Colors.white,
      body: WeSlide(
        isDismissible: false,
        controller: weSlideController,
        panelMinSize: context.watch<MusicPlayer>().isInitialized ? 70 : 0,
        panelMaxSize: size.height,
        body: WillPopScope(
          onWillPop: () async {
            if (queueController.isOpened) {
              queueController.hide();
              return false;
            }
            if (weSlideController.isOpened) {
              weSlideController.hide();
              return false;
            }

            if (_navigatorKey.currentState!.canPop()) {
              _navigatorKey.currentState!.pop();
              return false;
            }
            return true;
          },
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (_) => HomeScreen(
                            weSlideController: weSlideController,
                          ));
                case '/search':
                  return MaterialPageRoute(
                      builder: (_) => SearchScreen(
                            weSlideController: weSlideController,
                          ));
                case '/playlist':
                  Map<String, dynamic> args =
                      settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                      builder: (_) => PlayListScreen(
                            playlistId: args['playlistId'],
                            weSlideController: weSlideController,
                          ));
                default:
                  return MaterialPageRoute(builder: (_) => const Text("data"));
              }
            },
          ),
        ),
        panelHeader: (context.watch<MusicPlayer>().isInitialized &&
                context.watch<MusicPlayer>().song != null)
            ? Material(
                color: (context
                        .watch<MusicPlayer>()
                        .song
                        .colorPalette
                        ?.lightVibrantColor
                        ?.color) ??
                    tertiaryColor,
                child: InkWell(
                    onTap: () => weSlideController.show(),
                    child: const PanelHeader()),
              )
            : const SizedBox(),
        panel: PlayerScreen(
          queueController: queueController,
        ),
      ),
    );
  }
}
