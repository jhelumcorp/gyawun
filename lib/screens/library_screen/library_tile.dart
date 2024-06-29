import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/media_player.dart';
import '../../utils/bottom_modals.dart';
import '../../utils/extensions.dart';

class LibraryTile extends StatelessWidget {
  const LibraryTile({required this.songs, required this.index, super.key});
  final List songs;
  final int index;

  String _buildSubtitle(Map item) {
    List sub = [];
    if (sub.isEmpty && item['artists'] != null) {
      for (Map artist in item['artists']) {
        sub.add(artist['name']);
      }
    }
    if (sub.isEmpty && item['album'] != null) {
      sub.add(item['album']['name']);
    }
    String s = sub.join(' · ');
    return item['subtitle'] ?? s;
  }

  @override
  Widget build(BuildContext context) {
    Map song = songs[index];
    List thumbnails = song['thumbnails'];
    double height =
        (song['aspectRatio'] != null ? 50 / song['aspectRatio'] : 50)
            .toDouble();
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        await GetIt.I<MediaPlayer>().playAll(List.from(songs), index: index);
      },
      onSecondaryTap: () {
        if (song['videoId'] != null) {
          Modals.showSongBottomModal(context, song);
        }
      },
      onLongPress: () {
        if (song['videoId'] != null) {
          Modals.showSongBottomModal(context, song);
        }
      },
      child: Column(
        children: [
          ListTile(
            title: Text(song['title'] ?? "", maxLines: 1),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: CachedNetworkImage(
                imageUrl: thumbnails
                    .where((el) => el['width'] >= 50)
                    .toList()
                    .first['url'],
                height: height,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            subtitle: Text(
              _buildSubtitle(song),
              maxLines: 1,
              style: TextStyle(color: Colors.grey.withAlpha(250)),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: song['endpoint'] != null && song['videoId'] == null
                ? const Icon(CupertinoIcons.chevron_right)
                : null,
          ),
          if (song['type'] == 'EPISODE' && song['description'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ExpandableText(
                    song['description'].split('\n')?[0] ?? '',
                    expandText: 'Show More',
                    collapseText: 'Show Less',
                    maxLines: 3,
                    style: TextStyle(color: context.subtitleColor),
                  ),
                  const Divider(),
                ],
              ),
            )
        ],
      ),
    );
  }
}
