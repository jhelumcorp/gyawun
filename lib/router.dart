import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/features/home/home_screen.dart';
import 'package:gyawun_music/features/main/main_screen.dart';
import 'package:gyawun_music/features/onboarding/view/onboarding_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/browse/yt_browse_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/chip/yt_chip_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/yt_playlist_screen.dart';
import 'package:gyawun_music/features/search/search_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
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
                        path: 'chip/:body',
                        builder: (context, state) {
                          return YtChipScreen(
                            body: Map.from(
                              jsonDecode(state.pathParameters['body']!),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'browse/:body',
                        builder: (context, state) {
                          return YtBrowseScreen(
                            body: Map.from(
                              jsonDecode(state.pathParameters['body']!),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'playlist/:body',
                        builder: (context, state) {
                          return YtPlaylistScreen(
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
            ],
          ),
        ],
      ),
    ],
  );
}
