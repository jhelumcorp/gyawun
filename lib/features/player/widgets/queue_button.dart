import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/features/player/queue_screen.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({super.key, this.iconSize = 24, this.padding = const EdgeInsets.all(10)});
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton.filled(
        onPressed: () => _openQueue(context),
        padding: padding,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(cs.secondaryContainer), // <— ADDED
          foregroundColor: WidgetStatePropertyAll(
            cs.onSecondaryContainer,
          ), // <— ENSURES ICON CONTRAST
        ),
        icon: Icon(FluentIcons.list_24_filled, size: iconSize, color: cs.onSecondaryContainer),
      ),
    );
  }

  void _openQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      builder: (context) => const QueueScreen(),
    );
  }
}
