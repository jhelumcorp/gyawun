import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_music/features/services/yt_music/utils/click_handler.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';

class SectionRowTile extends StatelessWidget {
  const SectionRowTile({super.key, required this.item});

  final YTSectionItem item;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final imageHeight = (context.isWideScreen ? 200 : 150).toInt();
    final imageWidth = (item.isRectangle ? imageHeight * (16 / 9) : imageHeight)
        .toInt();
    final thumbnail = item.thumbnails.lastOrNull;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      enableFeedback: true,
      onTap: () => onYTSectionItemTap(context, item),
      onLongPress: () {
        Modals.showItemBottomSheet(context,item);
      },
      onSecondaryTap: () {
        Modals.showItemBottomSheet(context,item);
      },
      child: RepaintBoundary(
        child: SizedBox(
          height: context.isWideScreen ? 270 : 216,
          width: imageWidth.toDouble() + 16,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (thumbnail?.url != null)
                  Ink(
                    height: imageHeight.toDouble(),
                    width: imageWidth.toDouble(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        item.type == YTSectionItemType.artist
                            ? (imageWidth * pixelRatio)
                            : 8,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          thumbnail!.url,
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