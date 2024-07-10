import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:gyawun_beta/utils/enhanced_image.dart';
import 'package:provider/provider.dart';

import '../../services/media_player.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GetIt.I<MediaPlayer>().currentSongNotifier,
        builder: (context, currentSong, child) {
          return currentSong != null
              ? Container(
                  color: Platform.isWindows
                      ? fluent_ui.FluentTheme.of(context)
                          .scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.surfaceTint.withAlpha(20),
                  child: GestureDetector(
                    onTap: () {
                      context.push('/player');
                    },
                    child: SafeArea(
                      top: false,
                      child: Dismissible(
                        key: Key('bottomplayer${currentSong.id}'),
                        direction: DismissDirection.down,
                        confirmDismiss: (direction) async {
                          await GetIt.I<MediaPlayer>().stop();
                          return true;
                        },
                        child: Dismissible(
                          key: Key(currentSong.id),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await GetIt.I<MediaPlayer>()
                                  .player
                                  .seekToPrevious();
                            } else {
                              await GetIt.I<MediaPlayer>().player.seekToNext();
                            }
                            return Future.value(false);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: currentSong.extras?['offline'] ==
                                              true &&
                                          !currentSong.artUri
                                              .toString()
                                              .startsWith('https')
                                      ? Image.file(
                                          File.fromUri(currentSong.artUri!),
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: getEnhancedImage(currentSong
                                              .extras!['thumbnails']
                                              .first['url']),
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url, error) {
                                            return CachedNetworkImage(
                                              imageUrl: getEnhancedImage(
                                                  currentSong
                                                      .extras!['thumbnails']
                                                      .first['url'],
                                                  quality: 'medium'),
                                            );
                                          },
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          currentSong.title,
                                          // style: textStyle(context, bold: true),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (currentSong.artist != null ||
                                          currentSong.extras!['subtitle'] !=
                                              null)
                                        Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            currentSong.artist ??
                                                currentSong.extras!['subtitle'],
                                            // style: smallTextStyle(context),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable:
                                      GetIt.I<MediaPlayer>().buttonState,
                                  builder: (context, buttonState, child) {
                                    return (buttonState == ButtonState.loading)
                                        ? const AdaptiveProgressRing()
                                        : AdaptiveIconButton(
                                            onPressed: () {
                                              GetIt.I<MediaPlayer>()
                                                      .player
                                                      .playing
                                                  ? GetIt.I<MediaPlayer>()
                                                      .player
                                                      .pause()
                                                  : GetIt.I<MediaPlayer>()
                                                      .player
                                                      .play();
                                            },
                                            icon: Icon(
                                              buttonState == ButtonState.playing
                                                  ? AdaptiveIcons.pause
                                                  : AdaptiveIcons.play,
                                              size: 30,
                                            ),
                                          );
                                  },
                                ),
                                if (context.watch<MediaPlayer>().player.hasNext)
                                  AdaptiveIconButton(
                                    onPressed: () {
                                      GetIt.I<MediaPlayer>()
                                          .player
                                          .seekToNext();
                                    },
                                    icon: Icon(
                                      AdaptiveIcons.skip_next,
                                      size: 25,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
