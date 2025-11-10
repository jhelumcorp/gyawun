import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  const CustomImageIcon({
    super.key,
    required this.url,
    this.size = 64,
    this.borderRadius = 8,
  });

  final double size;
  final double borderRadius;
  final String? url;

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    // No thumbnail case
    if (url == null) {
      return Icon(
        FluentIcons.music_note_1_24_filled,
        size: size,
        color: Colors.grey,
      );
    }

    imageUrl = url!;
    // Select best thumbnail based on size
    if (size > 150) {
      imageUrl = url!.replaceAll('w60-h60', 'w500-h500');
    }

    // UI
    return ClipRRect(
      child: Image.network(
        imageUrl,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
