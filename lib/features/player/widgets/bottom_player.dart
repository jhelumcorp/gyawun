import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/player/widgets/queue_track_bar.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:just_audio/just_audio.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({
    super.key,
    this.height = 68,
    this.artworkSize = 55,
    this.iconSize = 28,
    this.buttonSize = 44,
  });
  final double height;
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
    final currentLocation = GoRouterState.of(context).uri.path;
    final isOnYTMusicRoute = currentLocation == '/';

    // Get the bottom navigation bar height (typically 56-80)
    final bottomNavBarHeight = isOnYTMusicRoute ? 80.0 : 0.0;
    return StreamBuilder<Color?>(
      stream: sl<MediaPlayer>().dominantSeedColorStream,
      builder: (context, snapshot) {
        final seed = snapshot.data;
        final baseTheme = Theme.of(context);
        final brightness = baseTheme.brightness;

        final generatedScheme = seed != null
            ? ColorScheme.fromSeed(seedColor: seed, brightness: brightness)
            : baseTheme.colorScheme;

        /// Preserve your scaffold background and other previously set colors
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
            bottom: bottomNavBarHeight + 8,
            left: 0,
            right: 0,
            child: SafeArea(
              child: StreamBuilder<bool>(
                stream: sl<MediaPlayer>().isActiveStream,
                builder: (context, activeSnap) {
                  final active = activeSnap.data ?? false;
                  if (!active) return const SizedBox.shrink();

                  return StreamBuilder<SequenceState>(
                    stream: sl<MediaPlayer>().queueStateStream,
                    builder: (context, queueSnap) {
                      final queueState = queueSnap.data;
                      final queue = queueState?.sequence;
                      if (queue == null || queue.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return SizedBox(
                        height: widget.height,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: queue.length,
                          onPageChanged: (index) {
                            final current = sl<MediaPlayer>().currentIndex;
                            if (current != index) {
                              sl<MediaPlayer>().skipToIndex(index);
                            }
                          },
                          itemBuilder: (context, index) {
                            final item = queue[index].tag as MediaItem;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: QueueTrackBar(
                                key: ValueKey(item.id),
                                item: item,
                                artworkSize: widget.artworkSize,
                                iconSize: widget.iconSize,
                                height: widget.height,
                              ),
                            );
                          },
                        ),
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
