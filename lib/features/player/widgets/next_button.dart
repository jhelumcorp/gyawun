import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    this.iconSize = 40,
    this.padding = const EdgeInsets.all(12),
    this.hideIfDisabled = false,
  });
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final bool hideIfDisabled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: sl<MediaPlayer>().hasNextStream,
      builder: (context, snapshot) {
        final canSkip = snapshot.data == true;
        final colorScheme = Theme.of(context).colorScheme;

        // NEW — hide the button completely if no next and hideIfDisabled is true
        if (!canSkip && hideIfDisabled) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(FluentIcons.next_28_filled),
          color: colorScheme.secondary,
          disabledColor: colorScheme.secondary.withValues(alpha: 0.5),
          padding: padding,
          onPressed: canSkip ? sl<MediaPlayer>().skipToNext : null,
          iconSize: iconSize,
        );
      },
    );
  }
}
