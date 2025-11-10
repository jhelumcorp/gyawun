import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/settings/appearance_settings.dart';
import 'package:gyawun_music/core/widgets/marquee.dart';
import 'package:gyawun_music/features/player/widgets/audio_progress_bar.dart';
import 'package:gyawun_music/features/player/widgets/loop_button.dart';
import 'package:gyawun_music/features/player/widgets/next_button.dart';
import 'package:gyawun_music/features/player/widgets/play_button.dart';
import 'package:gyawun_music/features/player/widgets/player_subtitle.dart';
import 'package:gyawun_music/features/player/widgets/player_thumbnail.dart';
import 'package:gyawun_music/features/player/widgets/player_title.dart';
import 'package:gyawun_music/features/player/widgets/previous_button.dart';
import 'package:gyawun_music/features/player/widgets/queue_button.dart';
import 'package:gyawun_music/features/player/widgets/shuffle_button.dart';
import 'package:gyawun_music/features/player/widgets/timer_button.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:ytmusic/models/models.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final appSettings = sl<AppSettings>();
  final media = sl<MediaPlayer>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return StreamBuilder<Color?>(
      stream: media.dominantSeedColorStream,
      builder: (context, snapshot) {
        final seed = snapshot.data;
        final baseTheme = Theme.of(context);
        final brightness = baseTheme.brightness;

        // Generate new scheme if seed exists, otherwise keep current
        final generatedScheme = seed != null
            ? ColorScheme.fromSeed(seedColor: seed, brightness: brightness)
            : baseTheme.colorScheme;

        // Preserve your custom scaffold background
        final dynamicTheme = baseTheme.copyWith(
          colorScheme: generatedScheme,
          scaffoldBackgroundColor: generatedScheme.surface,
          canvasColor: baseTheme.canvasColor,
        );

        return AnimatedTheme(
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutCubic,
          data: dynamicTheme,
          child: Scaffold(
            backgroundColor: dynamicTheme.colorScheme.surface,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background blur layer - now handles the stream internally
                _BackgroundBlurLayer(
                  media: media,
                  appearanceSettings: appSettings.appearanceSettings,
                ),

                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // App bar
                        AppBar(
                          leading: IconButton(
                            icon: const Icon(FluentIcons.arrow_down_24_filled),
                            onPressed: () => Navigator.pop(context),
                          ),
                          backgroundColor: Colors.transparent,
                        ),

                        // Thumbnail
                        PlayerThumbnail(
                          width: min(400, size.width) * 0.8,
                          borderRadius: 16,
                        ),

                        const SizedBox(height: 16),

                        // Title and subtitle
                        const MarqueeWidget(child: PlayerTitle()),
                        const PlayerSubtitle(),
                        const SizedBox(height: 16),

                        // Playback controls
                        const Column(
                          children: [
                            AudioProgressBar(),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ShuffleButton(iconSize: 24),
                                PreviousButton(iconSize: 30),
                                PlayButton(
                                  iconSize: 40,
                                  padding: EdgeInsets.all(16),
                                  isFilled: true,
                                ),
                                NextButton(iconSize: 30),
                                LoopButton(iconSize: 24),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimerButton(),
                            SizedBox(width: 8),
                            QueueButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Separated background blur layer with enable setting check
class _BackgroundBlurLayer extends StatelessWidget {
  const _BackgroundBlurLayer({
    required this.media,
    required this.appearanceSettings,
  });
  final MediaPlayer media;
  final AppearanceSettings appearanceSettings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: appearanceSettings.enableNewPlayerStream,
      builder: (context, enableSnapshot) {
        final blur = enableSnapshot.data == true;

        // Don't show blur if disabled
        if (!blur) return const SizedBox.shrink();

        return Positioned.fill(
          child: StreamBuilder<List<YTThumbnail>>(
            stream: media.thumbnailStream,
            builder: (context, snapThumbs) {
              final thumbs = snapThumbs.data;
              if (thumbs == null || thumbs.isEmpty) {
                return const SizedBox.shrink();
              }

              final url = thumbs.first.url.replaceAll('w60-h60', 'w500-h500');

              return RepaintBoundary(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _BlurredImage(key: ValueKey(url), url: url),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Optimized blurred image widget
class _BlurredImage extends StatelessWidget {
  const _BlurredImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
            tileMode: TileMode.clamp,
          ),
          child: Container(color: Colors.black.withValues(alpha: 0.28)),
        ),
      ),
    );
  }
}
