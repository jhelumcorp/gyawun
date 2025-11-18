import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/features/library/widgets/library_tile.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class LibrarySongTile extends StatelessWidget {
  const LibrarySongTile({
    super.key,
    required this.item,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });
  final PlayableItem item;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return LibraryTile(
      title: item.title,
      subtitle: item.subtitle,
      isFirst: isFirst,
      isLast: isLast,
      trailing: trailing,
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(0),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: CachedNetworkImageProvider(item.thumbnails.first.url)),
        ),
      ),
    );
  }
}
