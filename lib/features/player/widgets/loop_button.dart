import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:just_audio/just_audio.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({super.key, this.iconSize = 28});
  final double iconSize;

  void _toggleLoopMode(LoopMode mode) {
    final player = sl<MediaPlayer>();
    switch (mode) {
      case LoopMode.off:
        player.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        player.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        player.setLoopMode(LoopMode.off);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<LoopMode>(
      stream: sl<MediaPlayer>().loopModeStream.distinct(),
      builder: (context, snapshot) {
        final mode = snapshot.data ?? LoopMode.off;

        // Active = LoopMode.all or LoopMode.one
        final bool isActive = mode == LoopMode.all || mode == LoopMode.one;

        final Icon icon = switch (mode) {
          LoopMode.off => Icon(FluentIcons.arrow_repeat_all_24_regular, size: iconSize),
          LoopMode.all => Icon(FluentIcons.arrow_repeat_all_24_filled, size: iconSize),
          LoopMode.one => Icon(FluentIcons.arrow_repeat_1_24_filled, size: iconSize),
        };

        return IconButton.filled(
          isSelected: isActive,
          icon: icon,
          iconSize: iconSize,
          onPressed: () => _toggleLoopMode(mode),

          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (!isActive) {
                return cs.secondaryContainer;
              }
              return null;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (!isActive) {
                return cs.onSecondaryContainer;
              }
              return null;
            }),
          ),
        );
      },
    );
  }
}
