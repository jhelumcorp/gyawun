import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/components/play_button.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/screens/player_screen.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:provider/provider.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MediaManager mediaManager = context.watch<MediaManager>();
    MediaItem? song = mediaManager.currentSong;
    return song == null ||
            (MediaQuery.of(context).size.width >= 700 &&
                MediaQuery.of(context).size.height >= 600)
        ? const SizedBox.shrink()
        : Container(
            color: Theme.of(context).colorScheme.surfaceTint.withAlpha(20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Dismissible(
                            direction: DismissDirection.down,
                            background:
                                const ColoredBox(color: Colors.transparent),
                            key: const Key('playScreen'),
                            onDismissed: (direction) {
                              Navigator.pop(context);
                            },
                            child: const Material(child: PlayerScreen())),
                  )),
              child: SafeArea(
                top: false,
                child: Dismissible(
                  key: const Key('bottomplayer'),
                  direction: DismissDirection.down,
                  confirmDismiss: (direction) async {
                    await mediaManager.stop();
                    return true;
                  },
                  child: Dismissible(
                    key: Key(song.id),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        await mediaManager.previous();
                      } else {
                        await mediaManager.next();
                      }
                      return Future.value(false);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          Hero(
                            tag: "playerPoster",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: song.extras?['offline'] == true &&
                                      !song.artUri
                                          .toString()
                                          .startsWith('https')
                                  ? Image.file(
                                      File.fromUri(song.artUri!),
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: song.artUri.toString(),
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: "playerTitle",
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      song.title,
                                      style: textStyle(context, bold: true),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: "playerSubtitle",
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      song.artist ?? song.extras!['subtitle'],
                                      style: smallTextStyle(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Hero(
                              tag: "playerPlayButton", child: PlayButton())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
