import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/player/widgets/queue_track_bar.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/cubits/player_settings_cubit.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/player_settings_state.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({super.key, this.artworkSize = 55, this.iconSize = 28, this.buttonSize = 44});

  final double artworkSize;
  final double iconSize;
  final double buttonSize;

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    final currentIndex = sl<MediaPlayer>().currentIndex ?? 0;
    _pageController = PageController(initialPage: currentIndex);

    sl<MediaPlayer>().currentIndexStream.listen((idx) {
      if (_pageController.hasClients && idx != null) {
        _pageController.animateToPage(
          idx,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = sl<MediaPlayer>();
    final settingsCubit = sl<SettingsService>().player;

    final currentLocation = GoRouterState.of(context).uri.path;
    final isOnMainRoute = currentLocation == '/';
    final bottomNavBarHeight = isOnMainRoute ? 80.0 : 0.0;

    return StreamBuilder<Color?>(
      stream: media.dominantSeedColorStream,
      builder: (context, snapshot) {
        final seed = snapshot.data;
        final baseTheme = Theme.of(context);
        final brightness = baseTheme.brightness;

        final generatedScheme = seed != null
            ? ColorScheme.fromSeed(seedColor: seed, brightness: brightness)
            : baseTheme.colorScheme;

        final dynamicTheme = baseTheme.copyWith(
          colorScheme: generatedScheme,
          scaffoldBackgroundColor: baseTheme.scaffoldBackgroundColor,
          canvasColor: baseTheme.canvasColor,
        );

        return AnimatedTheme(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          data: dynamicTheme,
          child: AnimatedPositioned(
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
                  if (!active) return const SizedBox.shrink();

                  return BlocBuilder<PlayerSettingsCubit, PlayerSettingsState>(
                    bloc: settingsCubit,
                    builder: (context, playerSettings) {
                      return StreamBuilder(
                        stream: media.queueItemsStream.distinct(),
                        builder: (context, snap) {
                          final items = snap.data;

                          if (items == null || items.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return SizedBox(
                            height: 100,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: items.length,
                              onPageChanged: (index) {
                                final current = media.currentIndex;
                                if (current != index) {
                                  media.skipToIndex(index);
                                }
                              },
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  child: QueueTrackBar(
                                    key: ValueKey(item.id),
                                    item: item,
                                    artworkSize: widget.artworkSize,
                                    iconSize: widget.iconSize,
                                    hasNext: playerSettings.miniPlayerNextButton,
                                    hasPrevious: playerSettings.miniPlayerPreviousButton,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
