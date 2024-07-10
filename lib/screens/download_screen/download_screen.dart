import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

import '../../services/bottom_message.dart';
import '../../services/download_manager.dart';
import '../../services/media_player.dart';
import '../../utils/bottom_modals.dart';
import '../../utils/extensions.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: Text('Downloads'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ValueListenableBuilder(
                valueListenable: GetIt.I<DownloadManager>().downloads,
                builder: (context, allSongs, snapshot) {
                  List songs = allSongs
                      .where((song) =>
                          ['DOWNLOADED', 'DELETED'].contains(song['status']))
                      .toList();
                  return Column(
                    children: [
                      ...songs.indexed.map<Widget>((indexedSong) {
                        int index = indexedSong.$1;
                        Map song = indexedSong.$2;
                        return FutureBuilder(
                            future: File(song['path']).exists(),
                            builder: (context, snapshot) {
                              if (snapshot.data == false) {
                                GetIt.I<DownloadManager>()
                                    .updateStatus(song['videoId'], 'DELETED');
                                // return const SizedBox();
                              }
                              return SwipeActionCell(
                                backgroundColor: Colors.transparent,
                                key: ObjectKey(song['videoId']),
                                trailingActions: <SwipeAction>[
                                  if (snapshot.data == true)
                                    SwipeAction(
                                        title: "Remove",
                                        onTap:
                                            (CompletionHandler handler) async {
                                          Modals.showConfirmBottomModal(
                                            context,
                                            message:
                                                'Are you sure you want to remove it?',
                                            isDanger: true,
                                          ).then((bool confirm) {
                                            if (confirm) {
                                              GetIt.I<DownloadManager>()
                                                  .deleteSong(song['videoId'],
                                                      song['path'])
                                                  .then((message) =>
                                                      BottomMessage.showText(
                                                          context, message));
                                            }
                                          });
                                        },
                                        color: Colors.red),
                                ],
                                child: DownloadedSongTile(
                                    songs: songs, index: index),
                              );
                            });
                      })
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class DownloadedSongTile extends StatelessWidget {
  const DownloadedSongTile(
      {required this.songs, required this.index, this.playlistId, super.key});
  final String? playlistId;
  final List songs;
  final int index;
  @override
  Widget build(BuildContext context) {
    Map song = songs[index];
    List thumbnails = song['thumbnails'];
    double height =
        (song['aspectRatio'] != null ? 50 / song['aspectRatio'] : 50)
            .toDouble();
    return AdaptiveListTile(
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
      title: Text(song['title'] ?? "", maxLines: 1),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl:
              thumbnails.where((el) => el['width'] >= 50).toList().first['url'],
          height: height,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      subtitle: Text(
        song['status'] == 'DELETED' ? 'File not found' : _buildSubtitle(song),
        maxLines: 1,
        style: TextStyle(
          color: song['status'] == 'DELETED'
              ? Colors.red
              : Colors.grey.withAlpha(250),
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: song['status'] == 'DELETED'
          ? IconButton(
              onPressed: () async {
                await GetIt.I<DownloadManager>().downloadSong(song);
              },
              icon: const Icon(Icons.refresh))
          : null,
      description: song['type'] == 'EPISODE' && song['description'] != null
          ? ExpandableText(
              song['description'].split('\n')?[0] ?? '',
              expandText: 'Show More',
              collapseText: 'Show Less',
              maxLines: 3,
              style: TextStyle(color: context.subtitleColor),
            )
          : null,
    );
  }

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
}
