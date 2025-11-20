import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/router/route_paths.dart';
import 'package:gyawun_music/features/player/widgets/queue_track_bar.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/cubits/player_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/player_settings_state.dart';
import 'package:gyawun_shared/gyawun_shared.dart'; // Import PlayableItem

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({super.key, this.artworkSize = 55, this.iconSize = 28, this.buttonSize = 44});

  final double artworkSize;
  final double iconSize;
  final double buttonSize;

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  // Removed _pageController, no longer needed.
  // Removed initState logic for _pageController.

  @override
  Widget build(BuildContext context) {
    final media = sl<MediaPlayer>();
    final settingsCubit = sl<SettingsService>().player;

    final currentLocation = GoRouterState.of(context).uri.path;
    final isOnMainRoute = currentLocation == RoutePaths.home;
    final bottomNavBarHeight = isOnMainRoute ? 80.0 : 0.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: bottomNavBarHeight - 8,
      left: 0,
      right: 0,
      child: SafeArea(
        child: StreamBuilder<bool>(
          stream: media.isActiveStream,
          builder: (context, activeSnap) {
            final active = activeSnap.data ?? false;
            // Only show the player if a track is active
            if (!active) return const SizedBox.shrink();

            return BlocBuilder<PlayerSettingsCubit, PlayerSettingsState>(
              bloc: settingsCubit,
              builder: (context, playerSettings) {
                // Stream for the currently playing item
                return StreamBuilder<PlayableItem?>(
                  stream: media.currentItemStream,
                  builder: (context, itemSnap) {
                    final item = itemSnap.data;

                    // If there is no current item (which should be covered by isActiveStream, but safe to double-check)
                    if (item == null) {
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        // Display only the current track using QueueTrackBar
                        child: Dismissible(
                          key: Key('bottomplayer${item.id}'),
                          direction: DismissDirection.down,
                          confirmDismiss: (direction) async {
                            await sl<MediaPlayer>().stop();
                            return true;
                          },
                          child: Dismissible(
                            key: Key(item.provider.name + item.id),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                await sl<MediaPlayer>().skipToPrevious();
                              } else {
                                await sl<MediaPlayer>().skipToNext();
                              }
                              return Future.value(false);
                            },
                            child: QueueTrackBar(
                              key: ValueKey(item.id),
                              item: item,
                              artworkSize: widget.artworkSize,
                              iconSize: widget.iconSize,
                              hasNext: playerSettings.miniPlayerNextButton,
                              hasPrevious: playerSettings.miniPlayerPreviousButton,
                              // Tap action remains to navigate to the player screen
                              // onTap: () => context.push('/player'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
