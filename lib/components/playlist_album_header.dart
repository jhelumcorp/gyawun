import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/api/image_resolution_modifier.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/get_subtitle.dart';
import 'package:provider/provider.dart';

class PlaylistAlbumHeader extends StatelessWidget {
  const PlaylistAlbumHeader({
    super.key,
    required this.item,
    required this.songs,
  });

  final Map item;
  final List songs;

  @override
  Widget build(BuildContext context) {
    MediaManager mediaManager = context.read<MediaManager>();
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: getImageUrl(item['image']),
              width: min((constraints.maxWidth / 2) - 20, 150),
              height: min((constraints.maxWidth / 2) - 20, 150),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: constraints.maxWidth -
                40 -
                min((constraints.maxWidth / 2), 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['title'], style: textStyle(context), maxLines: 2),
                Text(getSubTitle(item), maxLines: 2),
                MaterialButton(
                  onPressed: () {
                    mediaManager.addAndPlay(songs);
                  },
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("Play All",
                      style: smallTextStyle(context, bold: true)),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
