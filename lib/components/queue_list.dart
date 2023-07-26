import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class QueueList extends StatelessWidget {
  const QueueList({required this.width, super.key});
  final double width;

  @override
  Widget build(BuildContext context) {
    MediaManager mediaManager = context.watch<MediaManager>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: 55 + MediaQuery.of(context).padding.bottom,
              bottom: MediaQuery.of(context).padding.bottom + 8),
          child: mediaManager.isShuffleModeEnabled
              ? ListView.builder(
                  // shrinkWrap: true,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  itemCount: mediaManager.songs.length,
                  itemBuilder: (context, index) {
                    MediaItem songItem = mediaManager.songs[index];

                    return QueueView(
                        index: index, songItem: songItem, width: width);
                  },
                )
              : ReorderableListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    await mediaManager.move(oldIndex, newIndex);
                  },
                  itemCount: mediaManager.songs.length,
                  itemBuilder: (context, index) {
                    MediaItem songItem = mediaManager.songs[index];

                    return QueueView(
                        key: ValueKey(songItem.id),
                        index: index,
                        songItem: songItem,
                        width: width);
                  },
                ),
        ),
      ),
    );
  }
}

class QueueView extends StatelessWidget {
  const QueueView(
      {required this.index,
      required this.width,
      required this.songItem,
      super.key});
  final MediaItem songItem;
  final int index;
  final double width;
  @override
  Widget build(BuildContext context) {
    MediaManager mediaManager = context.watch<MediaManager>();
    MediaItem? song = mediaManager.currentSong;
    return SizedBox(
      width: width,
      child: SwipeActionCell(
        key: ValueKey(songItem.id),
        trailingActions: <SwipeAction>[
          if (!mediaManager.isShuffleModeEnabled)
            SwipeAction(
                title: "delete",
                onTap: (CompletionHandler handler) async {
                  await handler(true);
                  await mediaManager.remove(index);
                },
                color: Colors.red),
        ],
        child: ListTile(
          onTap: () {
            if (song != songItem) {
              mediaManager.seek(Duration.zero, index: index);
            } else {
              mediaManager.play();
            }
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                songItem.extras?['offline'] == true &&
                        !songItem.artUri.toString().startsWith('http')
                    ? Image.file(
                        File.fromUri(songItem.artUri!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox();
                        },
                      )
                    : CachedNetworkImage(
                        imageUrl: songItem.artUri.toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill),
                if (song == songItem)
                  Container(
                    height: 50,
                    width: 50,
                    color: lightBlackColor.withOpacity(0.6),
                  ),
                if (song == songItem)
                  const Positioned(
                    width: 34,
                    height: 34,
                    left: 8,
                    top: 8,
                    child: Center(
                        child: Icon(
                      Iconsax.music,
                      color: Colors.white,
                    )),
                  )
              ],
            ),
          ),
          title: Text(songItem.title,
              style: smallTextStyle(context, bold: true), maxLines: 1),
          subtitle: Text(songItem.artist!,
              style: smallTextStyle(context), maxLines: 1),
          trailing: mediaManager.isShuffleModeEnabled
              ? null
              : const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
