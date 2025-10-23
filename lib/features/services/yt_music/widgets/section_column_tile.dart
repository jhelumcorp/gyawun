import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';

class SectionColumnTile extends StatelessWidget {
  final YTSectionItem item;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;
  const SectionColumnTile({
    super.key,
    required this.item,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  void playSong(BuildContext context, YTSectionItem item) async {
    if ([
      YTSectionItemType.video,
      YTSectionItemType.song,
      YTSectionItemType.episode,
    ].contains(item.type)) {}
  }

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final thumbnail = item.thumbnails.firstOrNull;

    return ListTile(
      onTap: () {
        playSong(context, item);
      },
      onLongPress: () {
        Modals.showItemBottomSheet(context, item);
      },
      enableFeedback: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(isFirst ? 20 : 4),
          topRight: Radius.circular(isFirst ? 20 : 4),
          bottomLeft: Radius.circular(isLast ? 20 : 4),
          bottomRight: Radius.circular(isLast ? 20 : 4),
        ),
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: thumbnail?.url == null
          ? null
          : SizedBox(
              width: 50,
              height: 50,
              child: AspectRatio(
                aspectRatio: item.type == YTSectionItemType.video ? 16 / 9 : 1,
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
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        item.subtitle ?? '',
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          Modals.showItemBottomSheet(context,item);
        },
        icon: Icon(Icons.more_vert_rounded),
      ),
    );
  }
}
