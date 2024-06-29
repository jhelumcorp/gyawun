import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../services/bottom_message.dart';
import '../../services/library.dart';
import '../../services/media_player.dart';
import '../../themes/colors.dart';
import '../../utils/bottom_modals.dart';
import '../home_screen/section_item.dart';
import '../../utils/extensions.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  const PlaylistDetailsScreen({required this.playlistkey, super.key});
  final String playlistkey;

  @override
  Widget build(BuildContext context) {
    Map? playlist = context.watch<LibraryService>().getPlaylist(playlistkey);
    return playlist == null
        ? const Scaffold(
            body: Center(
              child: Text('Not available'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(playlist['title']),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  MyPlayistHeader(playlist: playlist),
                  ReorderableListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      ...playlist['songs'].map<Widget>((song) {
                        return SwipeActionCell(
                          key: ObjectKey(song['videoId']),
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                                title: "Remove",
                                onTap: (CompletionHandler handler) async {
                                  Modals.showConfirmBottomModal(
                                    context,
                                    message:
                                        'Are you sure you want to remove it?',
                                    isDanger: true,
                                  ).then((bool confirm) {
                                    if (confirm) {
                                      context
                                          .read<LibraryService>()
                                          .removeFromPlaylist(
                                              item: song,
                                              playlistId: playlistkey)
                                          .then((message) =>
                                              BottomMessage.showText(
                                                  context, message));
                                    }
                                  });
                                },
                                color: Colors.red),
                          ],
                          child: SongTile(song: song, playlistId: playlistkey),
                        );
                      }).toList()
                    ],
                    onReorder: (oldIndex, newIndex) {},
                  )
                ],
              ),
            ),
          );
  }
}

class MyPlayistHeader extends StatelessWidget {
  const MyPlayistHeader({
    super.key,
    required this.playlist,
  });

  final Map playlist;

  _buildImage(List songs, double maxWidth,
      {bool isRound = false, bool isDark = false}) {
    return (songs.isNotEmpty)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 200,
              width: 200,
              child: StaggeredGrid.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                crossAxisCount: songs.length > 1 ? 2 : 1,
                children:
                    songs.sublist(0, min(songs.length, 4)).indexed.map((ind) {
                  int index = ind.$1;
                  Map song = ind.$2;
                  return CachedNetworkImage(
                    imageUrl: song['thumbnails']
                        .first['url']
                        .replaceAll('w540-h225', 'w60-h60')
                        .replaceAll('w60-h60', 'w225-h225'),
                    height:
                        (songs.length <= 2 || (songs.length == 3 && index == 0))
                            ? 255
                            : null,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
            ),
          )
        : Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(
              CupertinoIcons.music_note_list,
              color: isDark ? Colors.white : Colors.black,
            ),
          );
    // return ClipRRect(
    //     borderRadius: BorderRadius.circular(
    //         isRound ? min((thumbnail['height'] as int), 250).toDouble() : 8),
    //     child: CachedNetworkImage(
    //       imageUrl: thumbnail['url'].replaceAll('w60-h60', 'w225-h225'),
    //       width: min((thumbnail['height'] as int), 250).toDouble(),
    //       height: min((thumbnail['height'] as int), 250).toDouble(),
    //     ));
  }

  _buildContent(Map playlist, BuildContext context, {bool isRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isRow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment:
            isRow ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (playlist['songs'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${playlist['songs'].length} Songs', maxLines: 2),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (playlist['songs'].isNotEmpty)
                MaterialButton(
                  onPressed: () {
                    GetIt.I<MediaPlayer>().playAll(playlist['songs']);
                  },
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  child: Icon(
                    Icons.play_arrow_outlined,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 32,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth > 600
            ? Row(
                children: [
                  if (playlist['songs'] != null)
                    _buildImage(playlist['songs'], constraints.maxWidth,
                        isRound: playlist['type'] == 'ARTIST',
                        isDark: context.isDarkMode),
                  const SizedBox(width: 4),
                  Expanded(
                      child: _buildContent(playlist, context, isRow: true)),
                ],
              )
            : Column(
                children: [
                  if (playlist['songs'] != null)
                    _buildImage(playlist['songs'], constraints.maxWidth,
                        isRound: playlist['type'] == 'ARTIST',
                        isDark: context.isDarkMode),
                  SizedBox(height: playlist['thumbnails'] != null ? 4 : 0),
                  _buildContent(playlist, context),
                ],
              );
      }),
    );
  }
}
