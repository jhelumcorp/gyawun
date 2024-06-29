import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../services/media_player.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    MediaPlayer mediaPlayer = context.watch<MediaPlayer>();
    MediaItem? currentSong = mediaPlayer.currentSong;
    return currentSong != null
        ? Container(
            color: Theme.of(context).colorScheme.surfaceTint.withAlpha(20),
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
                    await mediaPlayer.stop();
                    return true;
                  },
                  child: Dismissible(
                    key: Key(currentSong.id),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        await mediaPlayer.player.seekToPrevious();
                      } else {
                        await mediaPlayer.player.seekToNext();
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
                            child: currentSong.extras?['offline'] == true &&
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
                                    imageUrl: currentSong
                                        .extras!['thumbnails'].first['url']
                                        .replaceAll('w60-h60', 'w300-h300'),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    currentSong.extras!['subtitle'] != null)
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
                          (mediaPlayer.buttonState == ButtonState.loading)
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  onPressed: () {
                                    mediaPlayer.player.playing
                                        ? mediaPlayer.player.pause()
                                        : mediaPlayer.player.play();
                                  },
                                  icon: Icon(
                                    mediaPlayer.buttonState ==
                                            ButtonState.playing
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 30,
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
  }
}
