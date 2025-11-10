import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class PlayerProgressRing extends StatelessWidget {
  const PlayerProgressRing({
    super.key,
    this.size = 48,
    this.strokeWidth = 3,
    this.color,
  });
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<PositionData>(
      stream: sl<MediaPlayer>().positionDataStream,
      builder: (context, snapshot) {
        final data = snapshot.data;

        final position = data?.position.inMilliseconds ?? 0;
        final duration = data?.duration?.inMilliseconds ?? 0;

        final progress = (duration > 0 ? (position / duration) : 0).toDouble();

        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            color: color ?? cs.primary,
          ),
        );
      },
    );
  }
}
