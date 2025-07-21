import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/extensions/list_extensions.dart';
import 'package:readmore/readmore.dart';
import 'package:yaru/widgets.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';

import '../utils/click_handler.dart';

class SectionItemGridTile extends StatelessWidget {
  final YTSectionItem item;
  final double width;
  final double height;

  const SectionItemGridTile({
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
                AspectRatio(
                  aspectRatio: item.isRectangle ? 16 / 9 : 1,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          item.thumbnails.byWidth(cappedImageWidth.toInt()).url,
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionItemRowTile extends StatelessWidget {
  const SectionItemRowTile({super.key, required this.item});

  final YTSectionItem item;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final imageHeight = (context.isWideScreen ? 200 : 150).toInt();
    final imageWidth = (item.isRectangle ? imageHeight * (16 / 9) : imageHeight)
        .toInt();
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      enableFeedback: true,
      onTap: () => onYTSectionItemTap(context, item),
      child: RepaintBoundary(
        child: SizedBox(
          height: context.isWideScreen ? 270 : 216,
          width: imageWidth.toDouble() + 16,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.thumbnails.isNotEmpty)
                  Ink(
                    height: imageHeight.toDouble(),
                    width: imageWidth.toDouble(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          item.thumbnails.byWidth(imageWidth).url,
                          maxHeight: (imageHeight * pixelRatio).round(),
                          maxWidth: (imageWidth * pixelRatio).round(),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionMultiRowColumn extends StatelessWidget {
  final YTSectionItem item;

  const SectionMultiRowColumn({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return InkWell(
      enableFeedback: true,
      onTap: () => onYTSectionItemTap(context, item),
      borderRadius: BorderRadius.circular(8),
      child: RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              YaruTile(
                leading: item.thumbnails.isEmpty
                    ? null
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              item.thumbnails.byWidth(50).url,
                              maxHeight: (50 * pixelRatio).round(),
                              maxWidth: (50 * pixelRatio).round(),
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                subtitle: Text(
                  item.subtitle ?? '',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (item.desctiption != null && item.desctiption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ReadMoreText(
                    item.desctiption!,
                    trimMode: TrimMode.Line,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionItemColumnTile extends StatelessWidget {
  final YTSectionItem item;
  const SectionItemColumnTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return InkWell(
      onTap: () => onYTSectionItemTap(context, item),
      enableFeedback: true,
      borderRadius: BorderRadius.circular(8),
      child: RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: YaruTile(
            leading: item.thumbnails.isEmpty
                ? null
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        item.type == YTSectionItemType.artist
                            ? ((50 * pixelRatio).round() / 2)
                            : 8,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          item.thumbnails.byWidth(50).url,
                          maxHeight: (50 * pixelRatio).round(),
                          maxWidth: (50 * pixelRatio).round(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            title: Text(
              item.title,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: Text(
              item.subtitle ?? '',
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
