import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
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
      stream: sl<MediaPlayer>().hasPreviousStream,
      builder: (context, snapshot) {
        final enabled = snapshot.data ?? false;
        final colorScheme = Theme.of(context).colorScheme;

        // NEW — hide when not available
        if (!enabled && hideIfDisabled) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(FluentIcons.previous_28_filled),
          color: colorScheme.secondary,
          disabledColor: colorScheme.secondary.withValues(alpha: 0.5),
          padding: padding,
          onPressed: enabled ? sl<MediaPlayer>().skipToPrevious : null,
          iconSize: iconSize,
        );
      },
    );
  }
}
