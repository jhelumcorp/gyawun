import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';
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
    return Material(
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
                  inactiveTrackColor: Colors.transparent,
                  activeTrackColor:
                      context.watch<ThemeProvider>().themeMode == 'light'
                          ? Colors.black
                          : Colors.white,
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
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}',
                      width: 54,
                      height: 54,
                      fit: BoxFit.fill,
                      errorWidget: (context, error, stackTrace) {
                        return Image.network(
                          song.thumbnails.last.url,
                          width: double.infinity,
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
                              return Icon(
                                player.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color:
                                    context.watch<ThemeProvider>().themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                              );
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
