import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/LanguageProvider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:vibe_music/widgets/MusicSlider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    required this.height,
    required this.percentage,
    super.key,
  });

  final double height;
  final double percentage;

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
    List<Track> songs = context.watch<MusicPlayer>().songs ?? [];
    Track? song = context.watch<MusicPlayer>().song;
    AudioPlayer player = context.watch<MusicPlayer>().player;
    Size size = MediaQuery.of(context).size;
    bool isDarkTheme =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: size.width - 64,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}',
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    song.thumbnails.last.url,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  );
                                },
                                width: double.infinity,
                                fit: BoxFit.fill,
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
                                                  fontWeight: FontWeight.w900,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                        Text(
                                          song.artists.first.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              overflow: TextOverflow.ellipsis,
                                              color: Color.fromARGB(
                                                  255, 93, 92, 92)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable:
                                        Hive.box('myfavourites').listenable(),
                                    builder: (context, Box box, child) {
                                      Map? favourite = box.get(song.videoId);
                                      return MaterialButton(
                                          padding: EdgeInsets.all(16),
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
                                              mapSong['timeStamp'] = timeStamp;

                                              box.put(song.videoId, mapSong);
                                            } else {
                                              box.delete(song.videoId);
                                            }
                                          },
                                          child: Icon(
                                            favourite == null
                                                ? CupertinoIcons.heart
                                                : CupertinoIcons.heart_fill,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
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
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  onPressed: () {
                                    context.read<MusicPlayer>().toggleShuffle();
                                  },
                                  shape: const CircleBorder(),
                                  child: Icon(
                                    Icons.shuffle_rounded,
                                    size: constraints.maxWidth > 30
                                        ? 30
                                        : constraints.maxWidth - 5,
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
                                        context.read<MusicPlayer>().previous();
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16),
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                    focusElevation: 0,
                                    hoverElevation: 0,
                                    disabledElevation: 0,
                                    highlightElevation: 0,
                                    onPressed: () {
                                      context.read<MusicPlayer>().togglePlay();
                                    },
                                    child: StreamBuilder(
                                        stream: player.playerStateStream,
                                        builder: (context, snapshot) {
                                          PlayerState? state = snapshot.data;
                                          if (state == null) {
                                            return const CircularProgressIndicator();
                                          }
                                          switch (state.processingState) {
                                            case ProcessingState.buffering:
                                            case ProcessingState.loading:
                                              return CircularProgressIndicator(
                                                color: isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              );
                                            case ProcessingState.completed:
                                              return Icon(
                                                  Icons.play_arrow_rounded,
                                                  size: constraints.maxWidth >
                                                          35
                                                      ? 35
                                                      : constraints.maxWidth -
                                                          5);
                                            case ProcessingState.idle:
                                              return Icon(
                                                  Icons.play_arrow_rounded,
                                                  size: constraints.maxWidth >
                                                          35
                                                      ? 35
                                                      : constraints.maxWidth -
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
                                                          5);
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
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  onPressed: () {
                                    context.read<MusicPlayer>().toggleLoop();
                                  },
                                  child: Icon(
                                    Icons.loop_rounded,
                                    size: constraints.maxWidth > 30
                                        ? 30
                                        : constraints.maxWidth - 5,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        ListTile(
                          onTap: (() {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return QueueScreen(
                                    song: song, /*songs: songs*/
                                  );
                                });
                          }),
                          title: Icon(
                            CupertinoIcons.music_note_list,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        )
                      ],
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
    bool isdarkTheme =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Directionality(
      textDirection: context.watch<LanguageProvider>().textDirection,
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
                child: Dismissible(
                  key: Key(song.videoId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await context.read<MusicPlayer>().removeAt(index);
                    if (songs.isEmpty) {
                      Navigator.pop(context);
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        "Remove from queue",
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
                    onTap: () {
                      if (player.currentIndex != index) {
                        player.play();
                      }
                    },
                    key: Key("$index"),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}',
                            width: 50,
                            height: 50,
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
                    subtitle: Text(
                      song.artists.first.name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 93, 92, 92)),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_handle,
                        color: isdarkTheme ? Colors.white : Colors.black,
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
  }
}
