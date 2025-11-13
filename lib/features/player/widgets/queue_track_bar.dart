import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/player/player_screen.dart';
import 'package:gyawun_music/features/player/widgets/next_button.dart';
import 'package:gyawun_music/features/player/widgets/play_button.dart';
import 'package:gyawun_music/features/player/widgets/previous_button.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class QueueTrackBar extends StatelessWidget {
  const QueueTrackBar({
    super.key,
    required this.item,
    required this.artworkSize,
    required this.iconSize,
    required this.hasNext,
    required this.hasPrevious,
  });
  final PlayableItem item;
  final double artworkSize;
  final double iconSize;
  final bool hasNext;
  final bool hasPrevious;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      elevation: 6,
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(35),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PlayerScreen(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _QueueArtwork(item: item, size: artworkSize),
              const SizedBox(width: 12),
              Expanded(child: _QueueTitleSubtitle(item: item)),
              if (hasPrevious) PreviousButton(iconSize: iconSize, hideIfDisabled: true),
              PlayButton(iconSize: iconSize + 4), // this still controls current playback
              if (hasNext) NextButton(iconSize: iconSize, hideIfDisabled: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _QueueArtwork extends StatelessWidget {
  const _QueueArtwork({required this.item, required this.size});
  final PlayableItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<MediaPlayer>().positionAndItemStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final (positions, mediaItem) = snapshot.data!;
        return CircleAvatar(
          radius: size / 2,
          backgroundImage: CachedNetworkImageProvider(item.thumbnails.first.url),
          child: snapshot.hasData && snapshot.data != null && mediaItem == item
              ? SizedBox(
                  height: size - 5,
                  width: size - 5,
                  child: CircularProgressIndicator(
                    value:
                        (positions.position.inMilliseconds.toDouble() /
                                (positions.duration?.inMilliseconds.toDouble() ??
                                    positions.position.inMilliseconds.toDouble()))
                            .clamp(0, 1),
                    padding: EdgeInsets.zero,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _QueueTitleSubtitle extends StatelessWidget {
  const _QueueTitleSubtitle({required this.item});
  final PlayableItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          item.artists.map((artist) => artist.name).join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}
