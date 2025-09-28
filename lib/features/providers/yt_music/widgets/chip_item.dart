
import 'package:flutter/material.dart';
import 'package:gyawun_music/features/providers/yt_music/chip/yt_chip_screen.dart';
import 'package:ytmusic/models/chip.dart';

class ChipItem extends StatelessWidget {
  const ChipItem({super.key, required this.chip});

  final YTChip chip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                YtChipScreen(body: chip.endpoint.cast(), title: chip.title),
          ),
        );
      },
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),

          // border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Text(
          chip.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            // color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
