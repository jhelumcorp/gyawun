import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ytmusic/mixins/mixins.dart';
import 'package:ytmusic/models/yt_item.dart';

class SectionGridTile extends StatelessWidget {
  final YTItem item;
  final double width;
  final double height;

  const SectionGridTile({
    super.key,
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final isHorizontal = (item is YTVideo || item is YTEpisode);
    final imageHeight = height * 0.7;
    final imageWidth = isHorizontal ? imageHeight * (16 / 9) : imageHeight;
    final cappedImageWidth = imageWidth > width ? width : imageWidth;
    final thumbnail = item is HasThumbnail ? (item as HasThumbnail).thumbnails.firstOrNull:null;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
      },
      child: RepaintBoundary(
        child: SizedBox(
          width: width,
          height: height,
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
                            maxHeight: (imageHeight * pixelRatio).round(),
                            maxWidth: (cappedImageWidth * pixelRatio).round(),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
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
    );
  }
}
