import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';

import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:vibe_music/widgets/MusicSlider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    required this.queueController,
    super.key,
  });

  final WeSlideController queueController;

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

    return song != null
        ? Container(
            color: lighten(
                song.colorPalette?.lightVibrantColor?.color ?? tertiaryColor),
            child: WeSlide(
              isDismissible: false,
              controller: widget.queueController,
              panelMinSize: 55,
              panelMaxSize: size.height,
              panelWidth: size.width,
              body: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: lighten(song.colorPalette?.lightVibrantColor?.color) ??
                      tertiaryColor,
                ),
                child: SafeArea(
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
                              song.thumbnails.last.url,
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
                            Text(
                              song.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              song.artists.first.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: grayColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const MusicSlider(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            elevation: 0,
                            padding: const EdgeInsets.all(8),
                            color: player.shuffleModeEnabled
                                ? (song.colorPalette?.lightVibrantColor
                                        ?.color ??
                                    primaryColor)
                                : Colors.transparent,
                            onPressed: () {
                              context.read<MusicPlayer>().toggleShuffle();
                            },
                            shape: const CircleBorder(),
                            child: Icon(
                              CupertinoIcons.shuffle,
                              color: player.loopMode == LoopMode.one
                                  ? song.colorPalette?.darkMutedColor?.color
                                  : Colors.black,
                              size: 30,
                            ),
                          ),
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                context.read<MusicPlayer>().previous();
                              },
                              icon: const Icon(
                                Icons.skip_previous,
                                size: 30,
                              )),
                          MaterialButton(
                            color:
                                song.colorPalette?.lightVibrantColor?.color ??
                                    primaryColor,
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
                                      return CircularProgressIndicator(
                                          color: song.colorPalette
                                                  ?.darkVibrantColor?.color ??
                                              primaryColor);
                                    case ProcessingState.loading:
                                      return CircularProgressIndicator(
                                          color: song.colorPalette
                                                  ?.darkVibrantColor?.color ??
                                              primaryColor);
                                    case ProcessingState.completed:
                                      return const Icon(Icons.play_arrow,
                                          size: 35);
                                    case ProcessingState.idle:
                                      return const Icon(Icons.play_arrow,
                                          size: 35);
                                    case ProcessingState.ready:
                                      return Icon(
                                          player.playing
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 35);
                                  }
                                }),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              context.read<MusicPlayer>().next();
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              size: 30,
                            ),
                          ),
                          MaterialButton(
                            padding: const EdgeInsets.all(8),
                            shape: const CircleBorder(),
                            elevation: 0,
                            color: player.loopMode == LoopMode.one
                                ? (song.colorPalette?.lightVibrantColor
                                        ?.color ??
                                    primaryColor)
                                : Colors.transparent,
                            onPressed: () {
                              context.read<MusicPlayer>().toggleLoop();
                            },
                            child: Icon(
                              Icons.loop,
                              color: player.loopMode == LoopMode.one
                                  ? song.colorPalette?.darkMutedColor?.color
                                  : Colors.black,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              panel: QueueScreen(song: song, songs: songs),
              panelHeader: context.watch<MusicPlayer>().isInitialized
                  ? Container(
                      color: context
                              .watch<MusicPlayer>()
                              .song
                              .colorPalette
                              ?.lightVibrantColor
                              ?.color ??
                          primaryColor,
                      child: ListTile(
                        onTap: () {
                          widget.queueController.show();
                        },
                        title: const Icon(
                          CupertinoIcons.music_note_list,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          )
        : const SizedBox();
  }
}

class QueueScreen extends StatelessWidget {
  const QueueScreen({
    Key? key,
    required this.song,
    required this.songs,
  }) : super(key: key);

  final Track song;
  final List<Track> songs;

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    return Container(
      color:
          lighten(song.colorPalette?.lightVibrantColor?.color) ?? tertiaryColor,
      child: SafeArea(
        child: ReorderableList(
          shrinkWrap: true,
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
              child: ListTile(
                onTap: () {
                  if (player.currentIndex != index) {
                    player.play();
                  }
                },
                key: Key("$index"),
                leading: Stack(
                  children: [
                    Image.network(
                      song.thumbnails.last.url,
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
                title: Text(
                  song.title,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                subtitle: Text(song.artists.first.name),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
