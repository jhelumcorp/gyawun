import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/item_click_handler.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class SectionColumnTile extends StatelessWidget {
  const SectionColumnTile({
    super.key,
    required this.item,
    this.onTap,
    this.items,
    this.isFirst = false,
    this.isLast = false,
  });
  final SectionItem item;
  final List<PlayableItem>? items;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;

  void playSong(BuildContext context, SectionItem item) {}

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final thumbnail = item.thumbnails.firstOrNull;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: ListTile(
        onTap: () {
          onSectionItemTap(context, item, items: items);
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: thumbnail?.url == null
            ? null
            : SizedBox(
                width: 50,
                height: 50,
                child: AspectRatio(
                  aspectRatio:
                      (item.type == SectionItemType.video || item.type == SectionItemType.episode)
                      ? 16 / 9
                      : 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        (item.type == SectionItemType.artist ||
                                item.type == SectionItemType.radioStation)
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: item.subtitle == null
            ? null
            : Text(
                item.subtitle!,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
        trailing: IconButton(
          onPressed: () {
            Modals.showItemBottomSheet(context, item);
          },
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
    );
  }
}
