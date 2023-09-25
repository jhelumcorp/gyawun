import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FavoriteDetails extends StatelessWidget {
  const FavoriteDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorites,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, Box box, child) {
          if (box.isEmpty) {
            return Center(child: Text(S.of(context).nothingInHere));
          }
          List songs = box.values.toList();
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Map song = songs[index];
              return SwipeActionCell(
                key: Key(song['id']),
                trailingActions: [
                  SwipeAction(
                    onTap: (CompletionHandler handler) async {
                      await handler(true);
                      await Hive.box('favorites').delete(song['id']);
                    },
                    title: S.of(context).delete,
                  )
                ],
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => context
                      .read<MediaManager>()
                      .addAndPlay(songs, initialIndex: index, autoFetch: false),
                  onLongPress: () => showSongOptions(context, Map.from(song)),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: song['offline'] == true
                        ? Image.file(
                            File(song['image']),
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          )
                        : CachedNetworkImage(
                            imageUrl: song['image'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                  ),
                  title: Text(
                    song['title'],
                    style: subtitleTextStyle(context, bold: true),
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    song['artist'],
                    style: smallTextStyle(context, bold: false),
                    maxLines: 1,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
