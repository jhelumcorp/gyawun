import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class PlayerSubtitle extends StatelessWidget {
  const PlayerSubtitle({super.key, this.style});
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Artist>?>(
      stream: sl<MediaPlayer>().subtitleStream,
      builder: (context, snapshot) {
        final subtitle = snapshot.data?.map((artist) => artist.name).join(', ');
        if (subtitle == null) {
          return const SizedBox.shrink();
        }
        return Text(
          subtitle,
          style: style ?? Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
