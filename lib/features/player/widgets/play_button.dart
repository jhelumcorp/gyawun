import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    this.iconSize = 50,
    this.padding = const EdgeInsets.all(8),
    this.isFilled = false,
  });
  final double iconSize; // actual icon size
  final EdgeInsetsGeometry? padding;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackButtonState>(
      stream: sl<MediaPlayer>().playbackStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackButtonState.paused;

        Widget icon;
        VoidCallback? onPressed;

        switch (state) {
          case PlaybackButtonState.loading:
            icon = SizedBox(
              height: iconSize,
              width: iconSize,
              child: const CircularProgressIndicator(strokeWidth: 3),
            );
            onPressed = null;
            break;

          case PlaybackButtonState.playing:
            icon = const Icon(FluentIcons.pause_24_filled);
            onPressed = sl<MediaPlayer>().pause;
            break;

          case PlaybackButtonState.paused:
            icon = const Icon(FluentIcons.play_24_filled);
            onPressed = sl<MediaPlayer>().play;
            break;
        }

        if (isFilled) {
          return IconButton.filled(
            isSelected: false,
            icon: icon,
            iconSize: iconSize,
            padding: padding,
            onPressed: onPressed,

            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                // When NOT selected → primaryContainer
                if (!states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.secondaryContainer;
                }
                return null; // selected → default IconButton.filled styling
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (!states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.onSecondaryContainer;
                }
                return null;
              }),
            ),
          );
        }
        return IconButton(
          isSelected: false,
          icon: icon,
          iconSize: iconSize,
          padding: padding,
          color: Theme.of(context).colorScheme.primary,
          onPressed: onPressed,
        );
      },
    );
  }
}
