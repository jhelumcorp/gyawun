import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/utils/colors.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicPlayer musicPlayer = context.watch<MusicPlayer>();
    AudioPlayer player = musicPlayer.player;
    Track song = musicPlayer.song;
    return Container(
      color: Colors.transparent,
      height: 70,
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          AbsorbPointer(
            child: SliderTheme(
              data: const SliderThemeData().copyWith(
                trackHeight: 2,
                inactiveTrackColor: Colors.transparent,
                activeTrackColor: Colors.black,
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
                        player.seek(Duration(milliseconds: value.floor()));
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(
                    song.thumbnails.first.url,
                    width: 54,
                    height: 54,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        song.artists.first.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: grayColor,
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
                            return CircularProgressIndicator(
                                color: song.colorPalette?.darkVibrantColor
                                        ?.color ??
                                    primaryColor);
                          case ProcessingState.loading:
                            return CircularProgressIndicator(
                                color: song.colorPalette?.darkVibrantColor
                                        ?.color ??
                                    primaryColor);
                          case ProcessingState.completed:
                            return const Icon(Icons.play_arrow);
                          case ProcessingState.idle:
                            return const Icon(Icons.play_arrow);
                          case ProcessingState.ready:
                            return Icon(player.playing
                                ? Icons.pause
                                : Icons.play_arrow);
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
