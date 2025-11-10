import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class AudioProgressBar extends StatefulWidget {
  const AudioProgressBar({super.key});

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  double? _dragValue;

  String _formatDuration(double milliseconds) {
    final d = Duration(milliseconds: milliseconds.floor());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final secs = twoDigits(d.inSeconds.remainder(60));
    return '${d.inHours > 0 ? '${twoDigits(d.inHours)}:' : ''}$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<PositionData>(
      stream: sl<MediaPlayer>().positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        final position =
            _dragValue ??
            (positionData?.position ?? Duration.zero).inMilliseconds.toDouble();
        final buffered = (positionData?.bufferedPosition ?? Duration.zero)
            .inMilliseconds
            .toDouble();
        final duration = (positionData?.duration ?? Duration.zero)
            .inMilliseconds
            .toDouble();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                overlayShape: SliderComponentShape.noOverlay,
                activeTrackColor: theme.colorScheme.primary,
                inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                secondaryActiveTrackColor: theme.colorScheme.secondary,
                thumbColor: theme.colorScheme.primary,
                trackHeight: 10,
                thumbSize: const WidgetStatePropertyAll(Size(5, 30)),
                year2023: false,
              ),
              child: Slider(
                value: position.clamp(0, duration > 0 ? duration : 1),
                min: 0,

                max: duration > 0 ? duration : 1,
                secondaryTrackValue: buffered,
                onChanged: (v) {
                  setState(() => _dragValue = v);
                },
                onChangeStart: (_) {
                  // Optional: pause auto updates during drag
                },
                onChangeEnd: (v) {
                  _dragValue = null;
                  sl<MediaPlayer>().seek(Duration(milliseconds: v.toInt()));
                },
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
