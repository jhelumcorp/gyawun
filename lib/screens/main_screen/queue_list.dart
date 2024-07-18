import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../services/media_player.dart';
import '../../utils/enhanced_image.dart';

class QueueList extends StatelessWidget {
  const QueueList({super.key});

  @override
  Widget build(BuildContext context) {
    MediaPlayer mediaPlayer = context.watch<MediaPlayer>();
    return ValueListenableBuilder(
        valueListenable: GetIt.I<MediaPlayer>().currentIndex,
        builder: (context, currentIndex, child) {
          return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withAlpha(70),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: ReorderableListView(
                            children: [
                              if (context.watch<MediaPlayer>().songList != null)
                                ...context
                                    .watch<MediaPlayer>()
                                    .songList!
                                    .indexed
                                    .map(
                                  (k) {
                                    int index = k.$1;
                                    MediaItem song = k.$2.tag;
                                    return Dismissible(
                                      key: Key(song.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        await context
                                            .read<MediaPlayer>()
                                            .playlist
                                            .removeAt(index);
                                        return true;
                                      },
                                      child: ListTile(
                                        key: Key(index.toString()),
                                        title: Text(
                                          song.title,
                                          maxLines: 1,
                                        ),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Stack(
                                            children: [
                                              song.extras?['offline'] == true &&
                                                      !song.artUri
                                                          .toString()
                                                          .startsWith('http')
                                                  ? Image.file(
                                                      File.fromUri(
                                                          song.artUri!),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const SizedBox();
                                                      },
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: getEnhancedImage(
                                                          song
                                                              .extras![
                                                                  'thumbnails']
                                                              .first['url'],
                                                          dp: MediaQuery.of(
                                                                  context)
                                                              .devicePixelRatio),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return CachedNetworkImage(
                                                          imageUrl: getEnhancedImage(
                                                              song
                                                                  .extras![
                                                                      'thumbnails']
                                                                  .first['url'],
                                                              dp: MediaQuery.of(
                                                                      context)
                                                                  .devicePixelRatio,
                                                              width: 50),
                                                        );
                                                      },
                                                    ),
                                              if (index == currentIndex)
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              if (index == currentIndex)
                                                const Positioned(
                                                  width: 34,
                                                  height: 34,
                                                  left: 8,
                                                  top: 8,
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.music_note_outlined,
                                                    color: Colors.white,
                                                  )),
                                                )
                                            ],
                                          ),
                                        ),
                                        subtitle: Text(
                                          song.artist ??
                                              song.album ??
                                              song.extras?['subtitle'] ??
                                              '',
                                          maxLines: 1,
                                        ),
                                        trailing: const Icon(Icons.drag_handle),
                                        onTap: () {
                                          GetIt.I<MediaPlayer>().player.seek(
                                              Duration.zero,
                                              index: index);
                                        },
                                      ),
                                    );
                                  },
                                ),
                            ],
                            onReorder: (oldIndex, newIndex) async {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              await mediaPlayer.playlist
                                  .move(oldIndex, newIndex);
                            },
                          ),
                        ),
                        if (Platform.isAndroid)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        mediaPlayer.shuffleModeEnabled
                                            ? Colors.white
                                            : Colors.white.withAlpha(50)),
                                    foregroundColor: WidgetStatePropertyAll(
                                        mediaPlayer.shuffleModeEnabled
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : Colors.white),
                                  ),
                                  onPressed: () {
                                    mediaPlayer.player.setShuffleModeEnabled(
                                        !mediaPlayer.shuffleModeEnabled);
                                  },
                                  icon: const Icon(Icons.shuffle_outlined),
                                  label: Text(S.of(context).Shuffle),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
