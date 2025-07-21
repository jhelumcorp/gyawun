import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/extensions/list_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/yt_playlist_screen.dart';
import 'package:yaru/widgets.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/pretty_print.dart';

import '../album/yt_album_screen.dart';

class SectionItemSquareTile extends StatelessWidget {
  final YTSectionItem item;
  final double width;
  final double height;

  const SectionItemSquareTile({
    super.key,
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    // Calculate image height inside the available height
    // Leave some space for title/subtitle and padding
    final imageHeight = height * 0.7;
    final imageWidth = item.isRectangle ? imageHeight * (16 / 9) : imageHeight;

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
                Ink(
                  height: imageHeight,
                  width: imageWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        item.thumbnails.byWidth(imageWidth.toInt()).url,
                        maxHeight: (imageHeight * pixelRatio).round(),
                        maxWidth: (imageWidth * pixelRatio).round(),
                      ),
                      fit: BoxFit.fill,
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
      onTap: () {
        if (item.endpoint == null) {
          return;
        }
        if (item.type == "MUSIC_PAGE_TYPE_PLAYLIST") {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => YtPlaylistScreen(body: item.endpoint!.cast()),
            ),
          );
        } else if (item.type == "MUSIC_PAGE_TYPE_ALBUM") {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => YtAlbumScreen(body: item.endpoint!.cast()),
            ),
          );
        } else {
          pprint(item);
        }
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

class SectionItemColumnTile extends StatefulWidget {
  final YTSectionItem item;
  const SectionItemColumnTile({super.key, required this.item});

  @override
  State<SectionItemColumnTile> createState() => _SectionItemColumnTileState();
}

class _SectionItemColumnTileState extends State<SectionItemColumnTile> {
  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: YaruTile(
            leading: widget.item.thumbnails.isEmpty
                ? null
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.item.thumbnails.byWidth(50).url,
                          maxHeight: (50 * pixelRatio).round(),
                          maxWidth: (50 * pixelRatio).round(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            title: Text(
              widget.item.title,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: Text(
              widget.item.subtitle ?? '',
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
