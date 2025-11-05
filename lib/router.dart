import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:gyawun_music/features/home/home_screen.dart';
import 'package:gyawun_music/features/library/library_screen.dart';
import 'package:gyawun_music/features/main/main_screen.dart';
import 'package:gyawun_music/features/onboarding/view/onboarding_screen.dart';
import 'package:gyawun_music/features/search/search_screen.dart';
import 'package:gyawun_music/features/settings/settings_screen.dart';
import 'package:gyawun_music/features/services/yt_music/album/yt_album_screen.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/browse/yt_browse_screen.dart';
import 'package:gyawun_music/features/services/yt_music/chip/yt_chip_screen.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/yt_playlist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/podcast/yt_podcast_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

ValueNotifier<int> bottomSheetCounter = ValueNotifier(0);

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // The main shell with bottom nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Home tab
        StatefulShellBranch(
          navigatorKey: homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'chip/:body/:title',
                  builder: (context, state) => YtChipScreen(
                    title: state.pathParameters['title']!,
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
                GoRoute(
                  path: 'browse/:body',
                  builder: (context, state) => YTBrowseScreen(
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
                GoRoute(
                  path: 'playlist/:body',
                  builder: (context, state) => YTPlaylistScreen(
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
                GoRoute(
                  path: 'album/:body',
                  builder: (context, state) => YTAlbumScreen(
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
                GoRoute(
                  path: 'artist/:body',
                  builder: (context, state) => YTArtistScreen(
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
                GoRoute(
                  path: 'podcast/:body',
                  builder: (context, state) => YTPodcastScreen(
                    body: Map.from(jsonDecode(state.pathParameters['body']!)),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Search tab
        StatefulShellBranch(
          navigatorKey: searchNavigatorKey,
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // Library tab
        StatefulShellBranch(
          navigatorKey: libraryNavigatorKey,
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),

        // Settings tab
        StatefulShellBranch(
          navigatorKey: settingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
