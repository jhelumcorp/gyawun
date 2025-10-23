
import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:gyawun_music/features/home/home_screen.dart';
import 'package:gyawun_music/features/library/library_screen.dart';
import 'package:gyawun_music/features/main/main_screen.dart';
import 'package:gyawun_music/features/onboarding/view/onboarding_screen.dart';
import 'package:gyawun_music/features/search/search_screen.dart';
import 'package:gyawun_music/features/services/yt_music/chip/yt_chip_screen.dart';
import 'package:gyawun_music/features/settings/settings_screen.dart';

import 'features/services/yt_music/browse/yt_browse_screen.dart';
import 'features/services/yt_music/playlist/yt_playlist_screen.dart';


GoRouter router=GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                MainScreen(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/home',
                    builder: (context, state) => const HomeScreen(),
                    routes: [
                      GoRoute(
                        path: 'chip/:body/:title',
                        builder: (context, state) {
                          return YtChipScreen(
                            title: state.pathParameters['title']!,
                            body: Map.from(
                              jsonDecode(state.pathParameters['body']!),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'browse/:body',
                        builder: (context, state) {
                          return YTBrowseScreen(
                            body: Map.from(
                              jsonDecode(state.pathParameters['body']!),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'playlist/:body',
                        builder: (context, state) {
                          return YTPlaylistScreen(
                            body: Map.from(
                              jsonDecode(state.pathParameters['body']!),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/search',
                    builder: (context, state) => const SearchScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/library',
                    builder: (context, state) => const LibraryScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
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
      ),
    ],
  );
