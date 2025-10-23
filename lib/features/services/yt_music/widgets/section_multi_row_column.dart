import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';

class SectionMultiRowColumn extends StatelessWidget {
  final YTSectionItem item;

  const SectionMultiRowColumn({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final thumbnail = item.thumbnails.firstOrNull;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),

      child: InkWell(
        enableFeedback: true,
        // onTap: () => onYTSectionItemTap(context, item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: RepaintBoundary(
            child: Column(
              children: [
                ListTile(
                  leading: thumbnail?.url == null
                      ? null
                      : SizedBox(
                          width: 50,
                          height: 50,
                          child: AspectRatio(
                            aspectRatio: item.type == YTSectionItemType.video
                                ? 16 / 9
                                : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  item.type == YTSectionItemType.artist
                                      ? ((50 * pixelRatio).round() / 2)
                                      : 8,
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    thumbnail!.url,
                                    maxHeight: (50 * pixelRatio).round(),
                                    maxWidth: (50 * pixelRatio).round(),
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle ?? '',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ),
                if (item.desctiption != null && item.desctiption!.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),

                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                      ),
                      child: Text(
                        item.desctiption!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
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