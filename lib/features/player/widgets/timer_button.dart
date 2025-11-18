import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({super.key, this.iconSize = 24});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final media = sl<MediaPlayer>();
    final theme = Theme.of(context);

    return StreamBuilder<String?>(
      stream: media.sleepTimerFormattedStream,
      builder: (context, snapshot) {
        final formatted = snapshot.data;
        final active = formatted != null;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => active ? media.cancelSleepTimer() : _showTimerMenu(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: active ? 16 : 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.8,
                        end: 1.0,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                      child: child,
                    ),
                  ),
                  child: !active
                      ? Icon(
                          FluentIcons.timer_24_regular,
                          key: const ValueKey("timer-off"),
                          size: iconSize,
                          color: theme.colorScheme.onSecondaryContainer,
                        )
                      : Row(
                          key: ValueKey("timer-on-$formatted"),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatted,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: theme.colorScheme.onSecondaryContainer,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              FluentIcons.dismiss_24_filled,
                              size: iconSize * 0.85,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTimerMenu(BuildContext context) {
    final media = sl<MediaPlayer>();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Presets
            for (final m in [5, 10, 15, 20, 30, 45, 60])
              ListTile(
                title: Text("$m minutes"),
                onTap: () {
                  media.startSleepTimer(m);
                  Navigator.pop(context);
                },
              ),

            const Divider(),

            // Custom entry button
            ListTile(
              title: const Text("Custom…"),
              leading: const Icon(FluentIcons.timer_24_regular),
              onTap: () {
                Navigator.pop(context);
                _showCustomTimerDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomTimerDialog(BuildContext context) {
    final media = sl<MediaPlayer>();

    int hours = 0;
    int minutes = 5; // start from a sensible default

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        Widget counter(String label, int value, VoidCallback onInc, VoidCallback onDec) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        onDec();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    Text(
                      value.toString().padLeft(2, '0'),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        onInc();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return AlertDialog(
          title: const Text("Set Sleep Timer"),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              counter(
                "Hours",
                hours,
                () => hours = (hours + 1).clamp(0, 23),
                () => hours = (hours - 1).clamp(0, 23),
              ),
              const SizedBox(width: 16),
              counter(
                "Minutes",
                minutes,
                () => minutes = (minutes + 1).clamp(0, 59),
                () => minutes = (minutes - 1).clamp(0, 59),
              ),
            ],
          ),
          actions: [
            TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
            FilledButton(
              child: const Text("Set"),
              onPressed: () {
                final total = hours * 60 + minutes;
                if (total > 0) media.startSleepTimer(total);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
