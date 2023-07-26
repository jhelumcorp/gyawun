import 'package:flutter/material.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    this.size = 30,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final MediaManager mediaManager = context.watch<MediaManager>();
    return IconButton(
      onPressed: () async {
        mediaManager.buttonState == ButtonState.playing
            ? mediaManager.pause()
            : mediaManager.play();
      },
      icon: (mediaManager.buttonState == ButtonState.loading)
          ? const CircularProgressIndicator()
          : Icon(mediaManager.buttonState == ButtonState.playing
              ? Iconsax.pause
              : Iconsax.play),
      iconSize: size,
    );
  }
}
