import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_exxtensions.dart';
import 'package:yaru/widgets.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/pretty_print.dart';

class SectionItemRowTile extends StatelessWidget {
  const SectionItemRowTile({super.key, required this.item});

  final YTSectionItem item;

  @override
  Widget build(BuildContext context) {
    final imageHeight = context.isWideScreen ? 200 : 150;
    final imageWidth = item.isRectangle ? imageHeight * (16 / 9) : imageHeight;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (item.type == "MUSIC_PAGE_TYPE_PLAYLIST" && item.endpoint != null) {
          context.push('/home/playlist/${jsonEncode(item.endpoint)}');
        } else {
          pprint(item);
        }
      },
      child: SizedBox(
        height: context.isWideScreen ? 270 : 216,
        width: imageWidth.toDouble() + 16,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink(
                height: imageHeight.toDouble(),
                width: imageWidth.toDouble(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.thumbnails.last.url),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionItemColumnTile extends StatefulWidget {
  final YTSectionItem item;
  const SectionItemColumnTile({super.key, required this.item});

  @override
  State<SectionItemColumnTile> createState() => _SectionItemColumnTileState();
}

class _SectionItemColumnTileState extends State<SectionItemColumnTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: YaruTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: widget.item.thumbnails.last.url,
              width: 50,
              height: 50,
            ),
          ),
          title: Text(widget.item.title, maxLines: 1),
          subtitle: Text(widget.item.subtitle ?? '', maxLines: 1),
        ),
      ),
    );
  }
}
