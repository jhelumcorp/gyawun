import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/screens/settings/equalizer_screen.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

showSongOptions(BuildContext context, Map<String, dynamic> song,
    {dynamic playlistKey}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 600 ? 600 : null,
          child: Material(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shrinkWrap: true,
              children: [
                Row(
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
                const Divider(),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<MediaManager>().playNext(song);
                  },
                  child: Text(S.of(context).playNext,
                      style: TextStyle(color: textStyle(context).color)),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<MediaManager>().addItems([song]);
                  },
                  child: Text(S.of(context).addToQueue,
                      style: TextStyle(color: textStyle(context).color)),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);

                    togglefavorite(song);
                  },
                  child: Text(
                      isfavorite(song['id'])
                          ? S.of(context).removeFromFavorites
                          : S.of(context).addToFavorites,
                      style: TextStyle(color: textStyle(context).color)),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EqualizerScreen()));
                  },
                  child: Text(S.of(context).equalizer,
                      style: TextStyle(color: textStyle(context).color)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  // showCupertinoModalPopup(
  //   context: context,
  //   builder: (context) => CupertinoActionSheet(
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: song['offline'] == true
  //               ? Image.file(File(song['image']),
  //                   width: 50, height: 50, fit: BoxFit.fill)
  //               : CachedNetworkImage(
  //                   imageUrl: song['image'], height: 50, width: 50),
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 song['title'],
  //                 style: textStyle(context),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               Text(
  //                 song['artist'],
  //                 style: smallTextStyle(context),
  //                 textAlign: TextAlign.start,
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //     actions: [
  //       CupertinoActionSheetAction(
  //         onPressed: () {
  //           Navigator.pop(context);
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (_) => const EqualizerScreen()));
  //         },
  //         child: Text(S.of(context).equalizer),
  //       ),
  //       CupertinoActionSheetAction(
  //         onPressed: () {
  //           Navigator.pop(context);
  //           context.read<MediaManager>().playNext(song);
  //         },
  //         child: Text(S.of(context).playNext),
  //       ),
  //       CupertinoActionSheetAction(
  //         onPressed: () {
  //           Navigator.pop(context);
  //           context.read<MediaManager>().addItems([song]);
  //         },
  //         child: Text(S.of(context).addToQueue),
  //       ),
  //       CupertinoActionSheetAction(
  //         onPressed: () {
  //           Navigator.pop(context);

  //           togglefavorite(song);
  //         },
  //         child: Text(isfavorite(song['id'])
  //             ? S.of(context).removeFromFavorites
  //             : S.of(context).addToFavorites),
  //       ),
  //     ],
  //   ),
  // );
}

bool isfavorite(dynamic id) {
  return Hive.box('favorites').get(id) != null;
}

togglefavorite(Map<String, dynamic> song) async {
  Box box = Hive.box('favorites');
  if (box.get(song['id']) == null) {
    Map newsong = Map.from(song);
    newsong['palette'] = null;
    await box.put(song['id'], newsong);
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
