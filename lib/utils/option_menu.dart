import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/snackbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

showSongOptions(BuildContext context, Map<String, dynamic> song,
    {dynamic playlistKey}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: song['offline'] == true
                ? Image.file(File(song['image']),
                    width: 50, height: 50, fit: BoxFit.fill)
                : CachedNetworkImage(
                    imageUrl: song['image'], height: 50, width: 50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'],
                  style: textStyle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song['artist'],
                  style: smallTextStyle(context),
                  textAlign: TextAlign.start,
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            context
                .read<MediaManager>()
                .playNext(song)
                .then((value) => Navigator.pop(context))
                .then(
                  (value) =>
                      ShowSnackBar().showSnackBar(context, 'Added to queue'),
                );
          },
          child: const Text("Play Next"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            context
                .read<MediaManager>()
                .addItems([song])
                .then((value) => Navigator.pop(context))
                .then((value) =>
                    ShowSnackBar().showSnackBar(context, 'Added to queue'));
          },
          child: const Text("Add To Queue"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            togglefavorite(song).then((value) => Navigator.pop(context)).then(
                (value) => ShowSnackBar().showSnackBar(
                    context,
                    isfavorite(song['id'])
                        ? "Added to Favorites"
                        : "Removed from Favorites"));
          },
          child: Text(isfavorite(song['id'])
              ? "Remove from Favorites"
              : "Add to Favorites"),
        ),
        // CupertinoActionSheetAction(
        //   onPressed: () {
        //     Navigator.pop(context);
        //     showAddToPlaylist(context, song);
        //   },
        //   child: const Text("Add to Playlist"),
        // ),
      ],
    ),
  );
}

bool isfavorite(dynamic id) {
  return Hive.box('favorites').get(id) != null;
}

togglefavorite(Map<String, dynamic> song) async {
  Box box = Hive.box('favorites');
  if (box.get(song['id']) == null) {
    await box.put(song['id'], song);
  } else {
    await box.delete(song['id']);
  }
}

// void showAddToPlaylist(BuildContext context, Map<String, dynamic> song) async {
//   await OnAudioRoom().queryPlaylists().then((playlists) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         title: Text(
//           "Add to Playlist",
//           style: textStyle(context),
//         ),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.pop(context);
//               showCreatePlaylist(context, songs: [song]);
//             },
//             child: const Text("Create new Playlist"),
//           ),
//           ...playlists
//               .map((e) => CupertinoActionSheetAction(
//                   onPressed: () {}, child: Text(e.playlistName)))
//               .toList()
//         ],
//       ),
//     );
//   });
// }
