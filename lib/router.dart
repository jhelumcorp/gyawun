import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/library/views/playlist_details.dart';
import 'package:gyawun_music/features/main/main_screen.dart';
import 'package:gyawun_music/features/onboarding/view/onboarding_screen.dart';
import 'package:gyawun_music/features/onboarding/view/setting_up_screen.dart';
import 'package:gyawun_music/features/player/player_screen.dart';
import 'package:gyawun_music/features/player/queue_screen.dart';
import 'package:gyawun_music/features/player/widgets/bottom_player.dart';
import 'package:gyawun_music/features/services/jio_saavn/album/js_album_screen.dart';
import 'package:gyawun_music/features/services/yt_music/album/yt_album_screen.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/browse/yt_browse_screen.dart';
import 'package:gyawun_music/features/services/yt_music/chip/yt_chip_screen.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/yt_playlist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/podcast/yt_podcast_screen.dart';
import 'package:gyawun_music/features/services/yt_music/search/yt_suggestions_screen.dart';
import 'package:gyawun_music/features/settings/views/about_screen.dart';
import 'package:gyawun_music/features/settings/views/appearance_screen.dart';
import 'package:gyawun_music/features/settings/views/jio_saavn_screen.dart';
import 'package:gyawun_music/features/settings/views/player_screen.dart' as settings;
import 'package:gyawun_music/features/settings/views/privacy_screen.dart';
import 'package:gyawun_music/features/settings/views/storage_screen.dart';
import 'package:gyawun_music/features/settings/views/youtube_music_screen.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/setup', builder: (context, state) => const SettingUpScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return Stack(children: [child, if (!context.isWideScreen) const BottomPlayer()]);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'ytmusic/playlist/:body',
              builder: (context, state) =>
                  YTPlaylistScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'ytmusic/chip/:body/:title/:type',
              builder: (context, state) => YtChipScreen(
                title: state.pathParameters['title']!,
                type: state.pathParameters['type'] == 'search' ? ChipType.search : ChipType.browse,
                body: Map.from(jsonDecode(state.pathParameters['body']!)),
              ),
            ),
            GoRoute(
              path: 'ytmusic/browse/:body',
              builder: (context, state) =>
                  YTBrowseScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'ytmusic/playlist/:body',
              builder: (context, state) =>
                  YTPlaylistScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'ytmusic/album/:body',
              builder: (context, state) =>
                  YTAlbumScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'jiosaavn/album/:id',
              builder: (context, state) => JSAlbumScreen(id: state.pathParameters['id']!),
            ),

            GoRoute(
              path: 'ytmusic/artist/:body',
              builder: (context, state) =>
                  YTArtistScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'ytmusic/podcast/:body',
              builder: (context, state) =>
                  YTPodcastScreen(body: Map.from(jsonDecode(state.pathParameters['body']!))),
            ),
            GoRoute(
              path: 'ytmusic/search/suggestions',
              pageBuilder: (context, state) => CustomTransitionPage(
                child: YTSuggestionsScreen(query: state.uri.queryParameters['q']),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),

            /// Library Routes
            GoRoute(
              path: 'library/playlists/:name/:id',
              builder: (context, state) => PlaylistDetailsScreen(
                name: state.pathParameters['name']!,
                id: state.pathParameters['id']!,
              ),
            ),

            //  Settings Screens
            GoRoute(
              path: 'settings/appearance',
              builder: (context, state) => const AppearanceScreen(),
            ),
            GoRoute(
              path: 'settings/player',
              builder: (context, state) => const settings.PlayerScreen(),
            ),
            GoRoute(
              path: 'settings/ytmusic',
              builder: (context, state) => const YoutubeMusicScreen(),
            ),
            GoRoute(path: 'settings/jiosaavn', builder: (context, state) => const JioSaavnScreen()),
            GoRoute(path: 'settings/storage', builder: (context, state) => const StorageScreen()),
            GoRoute(path: 'settings/privacy', builder: (context, state) => const PrivacyScreen()),
            GoRoute(path: 'settings/about', builder: (context, state) => const AboutScreen()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) {
        return const CupertinoPage(fullscreenDialog: true, child: PlayerScreen());
      },
      routes: [
        GoRoute(
          path: 'queue',
          pageBuilder: (context, state) {
            return const CupertinoPage(fullscreenDialog: true, child: QueueScreen());
          },
        ),
      ],
    ),
  ],
);
