import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/media_player.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../utils/extensions.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    super.key,
    this.size = 30,
  });

  final double size;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool playing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GetIt.I<MediaPlayer>().player.playing
            ? GetIt.I<MediaPlayer>().player.pause()
            : GetIt.I<MediaPlayer>().player.play();
      },
      child: ValueListenableBuilder(
        valueListenable: GetIt.I<MediaPlayer>().buttonState,
        builder: (context, buttonState, child) {
          if (GetIt.I<MediaPlayer>().player.playing != playing) {
            playing = GetIt.I<MediaPlayer>().player.playing;
            playing
                ? _animationController.forward()
                : _animationController.reverse();
          }
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (context.isDarkMode ? Colors.white : Colors.black)
                  .withAlpha(50),
              borderRadius: BorderRadius.circular(
                  buttonState == ButtonState.playing ? 15 : 40),
            ),
            child: (buttonState == ButtonState.loading)
                ? const AdaptiveProgressRing()
                : AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    size: 40,
                  ),
          );
        },
      ),
    );
  }
}
