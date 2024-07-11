import 'package:flutter/material.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/albums_screen.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/artists_screen.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/playlists_screen.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/songs_screen.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/subscriptions_screen.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

import 'youtube_history.dart';

class YTMScreen extends StatefulWidget {
  const YTMScreen({super.key});

  @override
  State<YTMScreen> createState() => _YTMScreenState();
}

class _YTMScreenState extends State<YTMScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: AdaptiveScaffold(
        appBar: AdaptiveAppBar(
          title: const Text('YTMusic'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            AdaptiveIconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    AdaptivePageRoute.create(
                        (context) => const YoutubeHistory()),
                  );
                })
          ],
          bottom: TabBar(
            labelColor: AdaptiveTheme.of(context).primaryColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            isScrollable: true,
            tabs: const [
              Tab(text: 'Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Playlists'),
              Tab(text: 'Artists'),
              Tab(text: 'Subscriptions')
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SongsScreen(),
            AlbumsScreen(),
            PlaylistsScreen(),
            ArtistsScreen(),
            SubscriptionsScreen()
          ],
        ),
      ),
    );
  }
}
