import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({super.key, this.iconSize = 24});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final media = sl<MediaPlayer>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: StreamBuilder<Duration?>(
        stream: media.sleepTimerRemainingStream, // <- NOW DURATION STREAM
        builder: (context, snapshot) {
          final remaining = snapshot.data;
          final active = remaining != null;

          // Convert duration into 4 sliding digits
          final digits = active ? formatDurationDigits(remaining) : const <String>[];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => active ? media.cancelSleepTimer() : _showTimerMenu(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(horizontal: active ? 16 : 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
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
                            key: const ValueKey("timer-on"),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _slidingDigit(digits[0]),
                              _slidingDigit(digits[1]),
                              Text(
                                ":",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              _slidingDigit(digits[2]),
                              _slidingDigit(digits[3]),
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
      ),
    );
  }

  // Convert Duration → ["M1", "M2", "S1", "S2"]
  List<String> formatDurationDigits(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return [...mm.split(''), ...ss.split('')];
  }

  Widget _slidingDigit(String digit) {
    return SizedBox(
      width: 10,
      // ClipRect is essential here to hide the text as it slides out of view
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          layoutBuilder: (currentChild, previousChildren) {
            // Standard layout builder to stack elements for the slide effect
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[...previousChildren, if (currentChild != null) currentChild],
            );
          },
          transitionBuilder: (child, animation) {
            // Identify if this child is the one entering or leaving
            final isIncoming = child.key == ValueKey(digit);

            if (isIncoming) {
              // INCOMING: Slide in from Bottom (Offset 0, 1) to Center
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              );
            } else {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInCubic)),
                child: child,
              );
            }
          },
          child: Text(
            digit,
            key: ValueKey(digit),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
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
            for (final m in [5, 10, 15, 20, 30, 45, 60])
              ListTile(
                title: Text(AppLocalizations.of(context)!.minutes(m)),
                onTap: () {
                  media.startSleepTimer(m);
                  Navigator.pop(context);
                },
              ),
            const Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context)!.customEllipsis),
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
    int minutes = 5;

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
          title: Text(AppLocalizations.of(context)!.setSleepTimer),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              counter(
                AppLocalizations.of(context)!.hours,
                hours,
                () => hours = (hours + 1).clamp(0, 23),
                () => hours = (hours - 1).clamp(0, 23),
              ),
              const SizedBox(width: 16),
              counter(
                AppLocalizations.of(context)!.minutesLabel,
                minutes,
                () => minutes = (minutes + 1).clamp(0, 59),
                () => minutes = (minutes - 1).clamp(0, 59),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            FilledButton(
              child: Text(AppLocalizations.of(context)!.set),
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
