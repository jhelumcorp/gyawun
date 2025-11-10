import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class PlayerTitle extends StatelessWidget {
  const PlayerTitle({super.key, this.style});
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: sl<MediaPlayer>().titleStream,
      builder: (context, snapshot) {
        final title = snapshot.data ?? '';
        return Text(
          title,
          style:
              style ??
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
