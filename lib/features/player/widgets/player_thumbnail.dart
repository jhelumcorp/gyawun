import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class PlayerThumbnail extends StatefulWidget {
  const PlayerThumbnail({super.key, this.width = 64, this.borderRadius = 8, this.onImageChanged});

  final double width;
  final double borderRadius;
  final void Function(String url)? onImageChanged;

  @override
  State<PlayerThumbnail> createState() => _PlayerThumbnailState();
}

class _PlayerThumbnailState extends State<PlayerThumbnail> {
  String? _currentUrl;

  @override
  Widget build(BuildContext context) {
    final media = sl<MediaPlayer>();

    return StreamBuilder<List<Thumbnail>?>(
      stream: media.thumbnailStream,
      builder: (context, snapshot) {
        final thumbs = snapshot.data;
        if (thumbs == null || thumbs.isEmpty) {
          return Icon(FluentIcons.music_note_1_24_filled, size: widget.width, color: Colors.grey);
        }
        String newUrl = thumbs.first.url.contains('w60-h60')
            ? thumbs.first.url.replaceAll('w60-h60', 'w300-h300')
            : thumbs.last.url;

        // Precache image before animating to it
        if (_currentUrl != newUrl) {
          precacheImage(CachedNetworkImageProvider(newUrl), context).then((_) {
            if (mounted) {
              setState(() => _currentUrl = newUrl);
            }
          });

          // Notify parent when ready
          if (widget.onImageChanged != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onImageChanged!(newUrl);
            });
          }
        }

        final activeUrl = _currentUrl ?? newUrl;

        return SizedBox(
          width: widget.width,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 550),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: ClipRRect(
              key: ValueKey(activeUrl),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: CachedNetworkImage(
                imageUrl: activeUrl,
                width: widget.width,
                fit: BoxFit.fitWidth, // Changed from cover to fitWidth
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        );
      },
    );
  }
}
