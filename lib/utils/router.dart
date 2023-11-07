import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/providers/theme_manager.dart';
import 'package:gyawun/screens/artists/artist_screen.dart';
import 'package:gyawun/screens/download_screen.dart';
import 'package:gyawun/screens/lists/list_screen.dart';
import 'package:gyawun/screens/main_screen.dart';
import 'package:gyawun/screens/main_screen/home_screen.dart';
import 'package:gyawun/screens/playlists/favorites_details.dart';
import 'package:gyawun/screens/playlists/playlists_screen.dart';
import 'package:gyawun/screens/search/main_search.dart';
import 'package:gyawun/screens/settings/about_screen.dart';
import 'package:gyawun/screens/settings/appearence.dart';
import 'package:gyawun/screens/settings/download_screen.dart';
import 'package:gyawun/screens/settings/equalizer_screen.dart';
import 'package:gyawun/screens/settings/history_screen.dart';
import 'package:gyawun/screens/settings/playback_screen.dart';
import 'package:gyawun/screens/settings/providers_screen.dart';
import 'package:gyawun/screens/settings/setting_screen.dart';

PageController pageController = PageController();
GoRouter router = GoRouter(
  navigatorKey: GetIt.I<GlobalKey<NavigatorState>>(),
  initialLocation: '/',
  routes: [
    ShellRoute(
        builder: (context, state, child) => Directionality(
            textDirection: GetIt.I<ThemeManager>().isRightToLeftDirection
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child),
        routes: [
          StatefulShellRoute.indexedStack(
            branches: branches,
            builder: (context, state, navigationShell) =>
                ScaffoldWithNestedNavigation(navigationShell: navigationShell),
          ),
        ]),
  ],
);

List<StatefulShellBranch> branches = [
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
          routes: [
            GoRoute(
              path: 'list',
              pageBuilder: (context, state) =>
                  CupertinoPage(child: ListScreen(list: state.extra as Map)),
            ),
            GoRoute(
              path: 'search',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: MainSearchScreen()),
              routes: [
                GoRoute(
                  path: 'list',
                  pageBuilder: (context, state) => CupertinoPage(
                      child: ListScreen(list: state.extra as Map)),
                ),
                GoRoute(
                  path: 'artist',
                  pageBuilder: (context, state) => CupertinoPage(
                      child:
                          ArtistScreen(artist: Map.from(state.extra as Map))),
                ),
              ],
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/playlists',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PlaylistsScreen()),
          routes: [
            GoRoute(
              path: 'favorite',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: FavoriteDetails()),
            ),
            GoRoute(
              path: 'saved',
              pageBuilder: (context, state) =>
                  CupertinoPage(child: ListScreen(list: state.extra as Map)),
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
        path: '/downloads',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DownloadsScreen()),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingScreen()),
          routes: [
            GoRoute(
              path: 'appearence',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: AppLayout()),
            ),
            GoRoute(
                path: 'playback',
                pageBuilder: (context, state) =>
                    const CupertinoPage(child: PlaybackScreen()),
                routes: [
                  GoRoute(
                    path: 'equilizer',
                    pageBuilder: (context, state) =>
                        const CupertinoPage(child: EqualizerScreen()),
                  ),
                ]),
            GoRoute(
              path: 'history',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: HistoryScreen()),
            ),
            // GoRoute(
            //   path: 'upi',
            //   pageBuilder: (context, state) => CupertinoPage(
            //       child: PaymentScreen(
            //     razorPay: state.extra as bool,
            //   )),
            // ),
            GoRoute(
              path: 'providers',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: ProvidersScreen()),
            ),
            GoRoute(
              path: 'download',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: DownloadScreen()),
            ),
            GoRoute(
              path: 'about',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: AboutScreen()),
            ),
          ]),
    ],
  ),
];
