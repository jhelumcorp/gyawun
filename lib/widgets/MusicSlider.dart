import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
// import 'package:vibe_music/providers/MusicPlayer.dart';

class MusicSlider extends StatelessWidget {
  const MusicSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.watch<MusicPlayer>().player;
    return StreamBuilder(
      stream: player.positionStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            player.duration != null &&
            snapshot.data!.inMilliseconds.toDouble() <=
                player.duration!.inMilliseconds.toDouble()) {
          return Column(
            children: [
              Slider(
                value: snapshot.data!.inMilliseconds.toDouble(),
                max: player.duration!.inMilliseconds.toDouble(),
                onChanged: ((value) {
                  player.seek(
                    Duration(
                      milliseconds: value.floor(),
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${snapshot.data!.inMinutes}:${(snapshot.data!.inSeconds - (snapshot.data!.inMinutes * 60)).toString().padLeft(2, '0')}",
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                  Text(
                    "${player.duration!.inMinutes}:${(player.duration!.inSeconds - (player.duration!.inMinutes * 60)).toString().padLeft(2, '0')}",
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          );
        }
        return Column(
          children: [
            Slider(
              value: 1,
              max: 1,
              onChanged: (value) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("0:00"),
                Text("0:00"),
              ],
            ),
          ],
        );
      }),
    );
  }
}
