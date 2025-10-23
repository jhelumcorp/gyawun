import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ytmusic/models/section.dart';

class SectionGridTile extends StatelessWidget {
  final YTSectionItem item;
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

    final imageHeight = height * 0.7;
    final imageWidth = item.isRectangle ? imageHeight * (16 / 9) : imageHeight;
    final cappedImageWidth = imageWidth > width ? width : imageWidth;
    final thumbnail = item.thumbnails.lastOrNull;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // your navigation code
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
                    aspectRatio: item.isRectangle ? 16 / 9 : 1,
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
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
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
