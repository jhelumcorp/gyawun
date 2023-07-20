import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/downlod.dart';
import 'package:gyavun/utils/get_subtitle.dart';
import 'package:gyavun/utils/option_menu.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SearchTile extends StatelessWidget {
  final Map item;
  const SearchTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String subtitle = getSubTitle(item);
    return ListTile(
      onTap: () {
        if (item['type'] == 'song') {
          context.read<MediaManager>().addAndPlay([item]);
        } else if (item['type'] == 'artist') {
          context.go('/search/artist', extra: item);
        } else {
          context.go('/search/list', extra: item);
        }
      },
      onLongPress: () => showSongOptions(context, Map.from(item)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: ClipRRect(
          borderRadius:
              BorderRadius.circular(item['type'] == 'artist' ? 30 : 8),
          child: CachedNetworkImage(
              imageUrl: item['image'], height: 50, width: 50)),
      title: Text(
        item['title'],
        style: subtitleTextStyle(context, bold: true),
        maxLines: 1,
      ),
      subtitle: subtitle == ''
          ? null
          : Text(
              getSubTitle(item),
              style: smallTextStyle(context),
              maxLines: 1,
            ),
    );
  }
}

class DownloadTile extends StatelessWidget {
  const DownloadTile({
    super.key,
    required this.index,
    required this.id,
    required this.path,
    required this.keys,
    required this.metadata,
  });

  final dynamic id;
  final String path;
  final List keys;
  final int index;
  final Metadata metadata;

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
        key: Key(index.toString()),
        trailingActions: [
          SwipeAction(
              onTap: (CompletionHandler handler) async {
                await handler(true);
                await deleteSong(key: id, path: path);
              },
              title: "Delete")
        ],
        child: ListTile(
          onTap: () {
            context.read<MediaManager>().addAndPlay(
                keys.map((e) => {'id': e}).toList(),
                initialIndex: index,
                autoFetch: false);
          },
          onLongPress: () async => showSongOptions(context, {
            'id': id,
            'title': metadata.title,
            'artist': metadata.artist,
            'album': metadata.album,
            'url': path,
            'image':
                '${(await getApplicationDocumentsDirectory()).path}/$id.jpg',
            'offline': true,
          }),
          title: Text(
            metadata.title!,
            style: subtitleTextStyle(context, bold: true),
            maxLines: 1,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(metadata.picture!.data, height: 50, width: 50),
          ),
          subtitle: Text(
            metadata.artist!,
            style: smallTextStyle(context),
            maxLines: 1,
          ),
        ));
  }
}
