import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/DownloadProvider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/providers/TD.dart';
import 'package:vibe_music/utils/file.dart';
import 'package:vibe_music/widgets/MusicSlider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Track? song = context.watch<MusicPlayer>().song;
    Map? item =
        song?.videoId != null ? Hive.box('downloads').get(song!.videoId) : null;
    AudioPlayer player = context.watch<MusicPlayer>().player;
    Size size = MediaQuery.of(context).size;

    return song != null
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('settings').listenable(),
                      builder: (context, Box box, child) {
                        bool isDarkTheme =
                            Theme.of(context).brightness == Brightness.dark;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height:
                                  size.width - 64 > 300 ? 300 : size.width - 64,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: item != null && item['art'] != null
                                      ? Image.file(File(item['art']))
                                      : Image.network(
                                          'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}',
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/images/song.png",
                                              fit: BoxFit.contain,
                                            );
                                          },
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(song.title,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                            if (song.artists.isNotEmpty)
                                              Text(
                                                song.artists
                                                    .map((e) => e.name)
                                                    .toList()
                                                    .join(', '),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w900,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Color.fromARGB(
                                                        255, 93, 92, 92)),
                                              ),
                                          ],
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable:
                                            Hive.box('myfavourites')
                                                .listenable(),
                                        builder: (context, Box box, child) {
                                          Map? favourite =
                                              box.get(song.videoId);
                                          return MaterialButton(
                                              padding: const EdgeInsets.all(16),
                                              elevation: 0,
                                              color: favourite != null
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.transparent,
                                              shape: const CircleBorder(),
                                              onPressed: () {
                                                if (favourite == null) {
                                                  int timeStamp = DateTime.now()
                                                      .millisecondsSinceEpoch;
                                                  Map<String, dynamic> mapSong =
                                                      song.toMap();
                                                  mapSong['timeStamp'] =
                                                      timeStamp;

                                                  box.put(
                                                      song.videoId, mapSong);
                                                } else {
                                                  box.delete(song.videoId);
                                                }
                                              },
                                              child: Icon(
                                                favourite == null
                                                    ? CupertinoIcons.heart
                                                    : CupertinoIcons.heart_fill,
                                                color: favourite == null
                                                    ? (isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black)
                                                    : (isDarkTheme
                                                        ? Colors.black
                                                        : Colors.white),
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const MusicSlider(),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return MaterialButton(
                                      elevation: 0,
                                      padding: const EdgeInsets.all(8),
                                      color: player.shuffleModeEnabled
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      onPressed: () {
                                        context
                                            .read<MusicPlayer>()
                                            .toggleShuffle();
                                      },
                                      shape: const CircleBorder(),
                                      child: Icon(
                                        Icons.shuffle_rounded,
                                        size: constraints.maxWidth > 30
                                            ? 30
                                            : constraints.maxWidth - 5,
                                        color: player.shuffleModeEnabled
                                            ? (isDarkTheme
                                                ? Colors.black
                                                : Colors.white)
                                            : (isDarkTheme
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    );
                                  }),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            context
                                                .read<MusicPlayer>()
                                                .previous();
                                          },
                                          icon: Icon(
                                            Icons.skip_previous_rounded,
                                            size: constraints.maxWidth > 30
                                                ? 30
                                                : constraints.maxWidth - 5,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ));
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return MaterialButton(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 16),
                                        shape: const CircleBorder(),
                                        elevation: 0,
                                        focusElevation: 0,
                                        hoverElevation: 0,
                                        disabledElevation: 0,
                                        highlightElevation: 0,
                                        onPressed: () {
                                          context
                                              .read<MusicPlayer>()
                                              .togglePlay();
                                        },
                                        child: StreamBuilder(
                                            stream: player.playerStateStream,
                                            builder: (context, snapshot) {
                                              PlayerState? state =
                                                  snapshot.data;
                                              if (state == null) {
                                                return const CircularProgressIndicator();
                                              }
                                              switch (state.processingState) {
                                                case ProcessingState.buffering:
                                                case ProcessingState.loading:
                                                  return CircularProgressIndicator(
                                                    color: isDarkTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                  );
                                                case ProcessingState.completed:
                                                  return Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      size: constraints
                                                                  .maxWidth >
                                                              35
                                                          ? 35
                                                          : constraints
                                                                  .maxWidth -
                                                              5);
                                                case ProcessingState.idle:
                                                  return Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      size: constraints
                                                                  .maxWidth >
                                                              35
                                                          ? 35
                                                          : constraints
                                                                  .maxWidth -
                                                              5);
                                                case ProcessingState.ready:
                                                  return Icon(
                                                    player.playing
                                                        ? Icons.pause_rounded
                                                        : Icons
                                                            .play_arrow_rounded,
                                                    size: constraints.maxWidth >
                                                            35
                                                        ? 35
                                                        : constraints.maxWidth -
                                                            5,
                                                    color: (isDarkTheme
                                                        ? Colors.black
                                                        : Colors.white),
                                                  );
                                              }
                                            }),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        context.read<MusicPlayer>().next();
                                      },
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        size: constraints.maxWidth > 30
                                            ? 30
                                            : constraints.maxWidth - 5,
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    );
                                  }),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return MaterialButton(
                                      padding: const EdgeInsets.all(8),
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      color: player.loopMode == LoopMode.one
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      onPressed: () {
                                        context
                                            .read<MusicPlayer>()
                                            .toggleLoop();
                                      },
                                      child: Icon(
                                        Icons.loop_rounded,
                                        size: constraints.maxWidth > 30
                                            ? 30
                                            : constraints.maxWidth - 5,
                                        color: player.loopMode == LoopMode.one
                                            ? (isDarkTheme
                                                ? Colors.black
                                                : Colors.white)
                                            : (isDarkTheme
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            ValueListenableBuilder(
                                valueListenable:
                                    Hive.box('downloads').listenable(),
                                builder: (context, Box box, child) {
                                  Map? item = box.get(song.videoId);
                                  double val = item?['progress'] ?? 0.00;
                                  Map? downloading = context
                                      .watch<DownloadManager>()
                                      .getSong(song.videoId);
                                  ChunkedDownloader? dl = context
                                      .watch<DownloadManager>()
                                      .getManager(song.videoId);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return QueueScreen(
                                                    song: song, /*songs: songs*/
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            CupertinoIcons.music_note_list,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        item != null
                                            ? Icon(Icons.download_done_rounded,
                                                size: 32,
                                                color: isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black)
                                            : (downloading != null
                                                ? IconButton(
                                                    onPressed: () {
                                                      if (dl?.paused != null) {
                                                        dl!.paused
                                                            ? dl.resume()
                                                            : dl.pause();
                                                      }
                                                    },
                                                    icon: Stack(
                                                      children: [
                                                        CircularProgressIndicator(
                                                          value: downloading[
                                                                      'progress'] !=
                                                                  null
                                                              ? (downloading[
                                                                      'progress'] /
                                                                  100)
                                                              : null,
                                                          color: isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          backgroundColor:
                                                              (isDarkTheme
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)
                                                                  .withOpacity(
                                                                      0.4),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child: Icon(
                                                            dl?.paused !=
                                                                        null &&
                                                                    dl!.paused
                                                                ? Icons
                                                                    .play_arrow_rounded
                                                                : Icons
                                                                    .pause_rounded,
                                                            color: isDarkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              DownloadManager>()
                                                          .download(song);
                                                    },
                                                    icon: Icon(
                                                        Icons.download_rounded,
                                                        size: 32,
                                                        color: isDarkTheme
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ))
                                      ],
                                    ),
                                  );
                                })
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          )
        : const SizedBox();
  }
}

class QueueScreen extends StatelessWidget {
  const QueueScreen({
    Key? key,
    required this.song,
    // required this.songs,
  }) : super(key: key);

  final Track song;
  // final List<Track> songs;

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    List<Track> songs = context.watch<MusicPlayer>().songs ?? [];
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, child) {
        bool darkTheme = Theme.of(context).brightness == Brightness.dark;
        return Directionality(
          textDirection: box.get('textDirection', defaultValue: 'ltr') == 'rtl'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: ReorderableList(
                primary: true,
                itemCount: songs.length,
                onReorder: (oldIndex, newIndex) {
                  int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                  context.read<MusicPlayer>().moveTo(oldIndex, index);
                },
                itemBuilder: (context, index) {
                  Track song = songs[index];
                  return Material(
                    color: Colors.transparent,
                    key: Key("$index"),
                    child: Directionality(
                      textDirection:
                          box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      child: Dismissible(
                        key: Key(song.videoId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await context.read<MusicPlayer>().removeAt(index);
                        },
                        background: Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              S.of(context).Remove_from_Queue,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        child: ListTile(
                          enableFeedback: false,
                          onTap: () {
                            player.seek(Duration.zero, index: index);
                            player.play();
                          },
                          key: Key("$index"),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                song.art != null
                                    ? Image.file(
                                        File(song.art!),
                                        width: 50,
                                        height: 50,
                                      )
                                    : Image.network(
                                        song.thumbnails.first.url,
                                        width: 50,
                                        height: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/song.png",
                                          width: 50,
                                          fit: BoxFit.fill,
                                          height: 50,
                                        ),
                                      ),
                                if (player.currentIndex == index)
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                    height: 50,
                                    width: 50,
                                    child: const Center(
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: song.artists.isNotEmpty
                              ? Text(
                                  song.artists
                                      .map((e) => e.name)
                                      .toList()
                                      .join(', '),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 93, 92, 92)),
                                )
                              : null,
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_handle,
                              color: darkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
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
