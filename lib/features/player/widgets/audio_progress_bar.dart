import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/audio_service/sponsor_block.dart';

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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'sponsor':
        return Colors.green.shade600;
      case 'selfpromo':
        return Colors.yellow.shade600;
      case 'interaction':
        return Colors.cyan.shade600;
      case 'intro':
        return Colors.blue.shade600;
      case 'outro':
        return Colors.blue.shade800;
      case 'preview':
        return Colors.purple.shade600;
      case 'music_offtopic':
        return Colors.orange.shade600;
      default:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<PositionData>(
      stream: sl<MediaPlayer>().positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        final position =
            _dragValue ?? (positionData?.position ?? Duration.zero).inMilliseconds.toDouble();
        final buffered = (positionData?.bufferedPosition ?? Duration.zero).inMilliseconds
            .toDouble();
        final duration = (positionData?.duration ?? Duration.zero).inMilliseconds.toDouble();

        return StreamBuilder<List<SponsorSegment>>(
          stream: sl<SponsorBlockService>().segmentsStream,
          builder: (context, segmentsSnapshot) {
            final segments = segmentsSnapshot.data ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // Main slider
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
                        secondaryTrackValue: buffered.clamp(0, duration > 0 ? duration : 1),
                        onChanged: (v) {
                          setState(() => _dragValue = v);
                        },
                        onChangeEnd: (v) {
                          setState(() => _dragValue = null);
                          sl<MediaPlayer>().seek(Duration(milliseconds: v.toInt()));
                        },
                      ),
                    ),
                    // Sponsor segment overlays
                    if (segments.isNotEmpty && duration > 0)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CustomPaint(
                              painter: SponsorSegmentPainter(
                                segments: segments,
                                duration: duration,
                                getCategoryColor: _getCategoryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
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
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Custom painter to draw sponsor segment indicators on the progress bar
class SponsorSegmentPainter extends CustomPainter {
  SponsorSegmentPainter({
    required this.segments,
    required this.duration,
    required this.getCategoryColor,
  });

  final List<SponsorSegment> segments;
  final double duration;
  final Color Function(String) getCategoryColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration <= 0) return;

    const trackHeight = 10.0;
    final trackY = (size.height - trackHeight) / 2;

    for (final segment in segments) {
      final startX = (segment.startTime * 1000 / duration) * size.width;
      final endX = (segment.endTime * 1000 / duration) * size.width;
      final width = (endX - startX).clamp(1.0, size.width);

      if (width > 0) {
        final paint = Paint()
          ..color = getCategoryColor(segment.category).withValues(alpha: 0.7)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX, trackY, width, trackHeight),
            const Radius.circular(5),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(SponsorSegmentPainter oldDelegate) {
    return segments != oldDelegate.segments || duration != oldDelegate.duration;
  }
}
