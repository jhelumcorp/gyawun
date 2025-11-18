import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({super.key, this.iconSize = 28});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final media = sl<MediaPlayer>();

    return StreamBuilder<bool>(
      stream: media.shuffleModeEnabledStream.distinct(),
      builder: (context, snapshot) {
        final enabled = snapshot.data == true;

        return IconButton.filled(
          isSelected: enabled,
          iconSize: iconSize,
          onPressed: () => media.setShuffleModeEnabled(!enabled),

          icon: Icon(FluentIcons.arrow_shuffle_off_24_filled, size: iconSize),
          selectedIcon: Icon(FluentIcons.arrow_shuffle_24_filled, size: iconSize),

          // Only apply primaryContainer when shuffle is OFF.
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (!states.contains(WidgetState.selected)) {
                return cs.secondaryContainer; // OFF → primaryContainer
              }
              return null; // ON  → default IconButton.filled background
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (!states.contains(WidgetState.selected)) {
                return cs.onSecondaryContainer; // OFF → readable icon color
              }
              return null; // ON → default icon color
            }),
          ),
        );
      },
    );
  }
}
