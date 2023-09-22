import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/api/extensions.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
import 'package:provider/provider.dart';

class SearchTile extends StatelessWidget {
  final Map item;
  const SearchTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (item['type'] == 'song' || item['type'] == 'video') {
          context.read<MediaManager>().addAndPlay([item]);
        } else if (item['type'] == 'artist') {
          context.go('/search/artist', extra: item);
        } else {
          context.go('/search/list', extra: item);
        }
      },
      onLongPress: () {
        if (item['type'] == 'song' || item['type'] == 'video') {
          showSongOptions(context, Map.from(item));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(
              item['type'].toString().capitalize() == 'Artist' ? 30 : 8),
          child: CachedNetworkImage(
            imageUrl: item['image'],
            height: 50,
            width: item['type'] == 'video' ? 80 : 50,
          )),
      title: Text(
        item['title'],
        style: subtitleTextStyle(context, bold: true),
        maxLines: 1,
      ),
      subtitle: Text(
        item['subtitle'],
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
    required this.items,
    required this.image,
  });

  final int index;
  final List<Map> items;
  final Uri image;

  @override
  Widget build(BuildContext context) {
    Map song = items[index];

    return ListTile(
      onTap: () {
        context.read<MediaManager>().addAndPlay(
            items.map((e) => {'id': e['id']}).toList(),
            initialIndex: index,
            autoFetch: false);
      },
      onLongPress: () async => showSongOptions(context, {
        'id': song['id'],
        'title': song['title'],
        'artist': song['artist'],
        'album': song['album'],
        'url': song['path'],
        'image': image.path,
        'offline': true,
      }),
      title: Text(
        song['title'],
        style: subtitleTextStyle(context, bold: true),
        maxLines: 1,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File.fromUri(image),
          height: 50,
          width: 50,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(song['image']);
          },
        ),
      ),
      subtitle: Text(
        song['artist'],
        style: smallTextStyle(context),
        maxLines: 1,
      ),
    );
  }
}
