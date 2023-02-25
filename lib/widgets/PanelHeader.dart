import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    Key? key,
    required this.song,
  }) : super(key: key);
  final Track song;

  @override
  Widget build(BuildContext context) {
    MusicPlayer musicPlayer = context.watch<MusicPlayer>();
    AudioPlayer player = musicPlayer.player;
    // Track? song = musicPlayer.song;
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, child) {
        bool darkTheme = Theme.of(context).brightness == Brightness.dark;
        return Directionality(
          textDirection: box.get('textDirection', defaultValue: 'ltr') == 'rtl'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
            elevation: 20,
            child: Container(
              height: 70,
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  AbsorbPointer(
                    child: SliderTheme(
                      data: const SliderThemeData().copyWith(
                        trackHeight: 2,
                        thumbColor: Colors.black,
                        inactiveTrackColor: darkTheme
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                        activeTrackColor:
                            darkTheme ? Colors.white : Colors.black,
                        thumbShape: SliderComponentShape.noThumb,
                        trackShape: const RectangularSliderTrackShape(),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: StreamBuilder(
                        stream: player.positionStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              player.duration != null &&
                              snapshot.data!.inMilliseconds.toDouble() <=
                                  player.duration!.inMilliseconds.toDouble()) {
                            return Slider(
                              value: snapshot.data!.inMilliseconds.toDouble(),
                              max: player.duration!.inMilliseconds.toDouble(),
                              onChanged: ((value) {
                                player.seek(
                                    Duration(milliseconds: value.floor()));
                              }),
                            );
                          }
                          return Slider(
                            value: 0,
                            max: 1,
                            onChanged: ((value) {}),
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: song.art != null
                              ? Image.file(
                                  File(song.art!),
                                  width: 54,
                                  height: 54,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  song.thumbnails.first.url,
                                  width: 54,
                                  height: 54,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/song.png",
                                      width: 50,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              if (song.artists.isNotEmpty)
                                Text(
                                  song.artists.first.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 93, 92, 92),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<MusicPlayer>().togglePlay();
                          },
                          icon: StreamBuilder(
                              stream: player.playerStateStream,
                              builder: (context, snapshot) {
                                PlayerState? state = snapshot.data;
                                if (state == null) {
                                  return const CircularProgressIndicator();
                                }
                                switch (state.processingState) {
                                  case ProcessingState.buffering:
                                  case ProcessingState.loading:
                                    return const CircularProgressIndicator();
                                  case ProcessingState.idle:
                                  case ProcessingState.completed:
                                    return Icon(
                                      Icons.play_arrow_rounded,
                                      color: darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    );
                                  case ProcessingState.ready:
                                    return Icon(
                                      player.playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    );
                                  default:
                                    return const CircularProgressIndicator();
                                }
                              }),
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<MusicPlayer>().next();
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              color: darkTheme ? Colors.white : Colors.black,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
