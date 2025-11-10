import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class BottomPlayingPadding extends StatelessWidget {
  const BottomPlayingPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<MediaPlayer>().hasQueueItemsStream,
      builder: (context, snapshot) {
        return SizedBox(
          height: snapshot.hasData && snapshot.data == true ? 100 : 0,
        );
      },
    );
  }
}
