import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../screens/download_screen/download_screen.dart';
import '../screens/home_screen/chip_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/home_screen/search_screen/search_screen.dart';
import '../screens/library_screen/library_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../screens/main_screen/player_screen.dart';
import '../screens/playlist_screen/browse_screen.dart';
import '../screens/settings_screen/about/about_screen.dart';
import '../screens/settings_screen/appearence/appearence_screen.dart';
import '../screens/settings_screen/backup_restore/backup_restore_screen.dart';
import '../screens/settings_screen/content/content_screen.dart';
import '../screens/settings_screen/playback/audio_and_playback_screen.dart';
import '../screens/settings_screen/playback/equalizer_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        StatefulShellRoute.indexedStack(
            branches: branches,
            builder: (context, state, navigationShell) =>
                MainScreen(navigationShell: navigationShell)),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) {
        return const CupertinoPage(
          name: 'player',
          child: PlayerScreen(),
          fullscreenDialog: true,
        );
      },
    ),
  ],
);

List<StatefulShellBranch> branches = [
  StatefulShellBranch(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'chip',
              builder: (context, state) {
                Map<String, dynamic> args = state.extra as Map<String, dynamic>;
                return ChipScreen(
                    title: args['title'] ?? '',
                    endpoint: args['endpoint'] ?? {});
              },
            ),
            GoRoute(
              path: 'browse',
              builder: (context, state) {
                Map<String, dynamic> args = state.extra as Map<String, dynamic>;
                return BrowseScreen(endpoint: args);
              },
            ),
            GoRoute(
              path: 'search',
              builder: (context, state) => const SearchScreen(),
            ),
          ]),
    ],
  ),
  StatefulShellBranch(routes: [
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
      path: '/download',
      builder: (context, state) => const DownloadScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'appearence',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: AppearenceScreen()),
          ),
          GoRoute(
            path: 'content',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: ContentScreen()),
          ),
          GoRoute(
              path: 'playback',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: AudioAndPlaybackScreen()),
              routes: [
                GoRoute(
                  path: 'equalizer',
                  pageBuilder: (context, state) =>
                      const CupertinoPage(child: EqualizerScreen()),
                )
              ]),
          GoRoute(
            path: 'backup_restore',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: BackupRestoreScreen()),
          ),
          GoRoute(
            path: 'about',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: AboutScreen()),
          ),
        ]),
  ])
];
