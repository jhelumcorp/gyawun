import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_music/features/services/yt_music/utils/click_handler.dart';
import 'package:ytmusic/mixins/mixins.dart';
import 'package:ytmusic/models/yt_item.dart';

class SectionGridTile extends StatelessWidget {
  const SectionGridTile({super.key, required this.item, required this.width});
  final YTItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = (item is YTVideo || item is YTEpisode);
    // final imageHeight = (context.isWideScreen ? 200 : 150).toInt();
    // final imageWidth = (isHorizontal? imageHeight * (16 / 9) : imageHeight);
    final imageWidth = width - 16;
    final imageHeight = isHorizontal ? imageWidth * (9 / 16) : imageWidth;
    final thumbnail = item is HasThumbnail
        ? (item as HasThumbnail).thumbnails.lastOrNull
        : null;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          onYTSectionItemTap(context, item);
        },
        onLongPress: () {
          Modals.showItemBottomSheet(context, item);
        },
        onSecondaryTap: () {
          Modals.showItemBottomSheet(context, item);
        },
        child: RepaintBoundary(
          child: SizedBox(
            width: imageWidth.toDouble(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (thumbnail?.url != null)
                    AspectRatio(
                      aspectRatio: isHorizontal ? 16 / 9 : 1,
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              thumbnail!.url,
                              maxWidth: imageWidth.toInt(),
                              maxHeight: imageHeight.toInt(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
