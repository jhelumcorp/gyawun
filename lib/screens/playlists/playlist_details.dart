import 'package:flutter/material.dart';

class Playlistdetails extends StatelessWidget {
  const Playlistdetails({required this.playlistKey, super.key});
  final dynamic playlistKey;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return StreamBuilder(
    //   stream: Hive.box<Playlist>('playlists').watch(key: playlistKey),
    //   builder: (context, snapshot) {
    //     Playlist playlist = Hive.box<Playlist>('playlists').get(playlistKey)!;
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: Text(
    //           playlist.name,
    //           style: mediumTextStyle(context, bold: false),
    //         ),
    //         centerTitle: true,
    //       ),
    //       body: ListView.builder(
    //         padding: const EdgeInsets.symmetric(horizontal: 8),
    //         itemCount: playlist.songs.length,
    //         itemBuilder: (context, index) {
    //           Map song = playlist.songs[index];
    //           return SwipeActionCell(
    //             key: Key(song['id']),
    //             trailingActions: [
    //               SwipeAction(
    //                   onTap: (CompletionHandler handler) async {
    //                     await handler(true);
    //                     await toggleplaylist(Map.from(song), playlistKey);
    //                   },
    //                   title: "Remove",
    //                   style: smallTextStyle(context))
    //             ],
    //             child: ListTile(
    //               onTap: () {
    //                 context.read<MediaManager>().addAndPlay(playlist.songs,
    //                     initialIndex: index, autoFetch: false);
    //               },
    //               onLongPress: () => showSongOptions(context, Map.from(song),
    //                   playlistKey: playlistKey),
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(8)),
    //               leading: ClipRRect(
    //                   borderRadius: BorderRadius.circular(
    //                       song['type'] == 'artist' ? 30 : 8),
    //                   child: song['offline'] == true
    //                       ? Image.file(File(song['image']),
    //                           height: 50, width: 50)
    //                       : CachedNetworkImage(
    //                           imageUrl: song['image'], height: 50, width: 50)),
    //               title: Text(
    //                 song['title'],
    //                 style: subtitleTextStyle(context, bold: true),
    //                 maxLines: 1,
    //               ),
    //               subtitle: Text(
    //                 song['artist'],
    //                 style: smallTextStyle(context),
    //                 maxLines: 1,
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }
}
