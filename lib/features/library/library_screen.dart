import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/widgets/custom_tile.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/yt_playlist_screen.dart';
import 'package:gyawun_music/providers/playlist_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Library")),
      body: StreamBuilder(
        stream: ref.read(playlistServiceProvider).watchAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final playlists = snapshot.data!;
            return ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return CustomTile(
                  title: Text(playlist.title),
                  leading: null,
                  isFirst: index == 0,
                  isLast: index == playlists.length - 1,
                  onTap: () {
                    if (playlist.endpoint == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YtPlaylistScreen(body: playlist.endpoint!),
                      ),
                    );
                  },
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
      // body: ref
      //     .watch(playlistsProvider)
      //     .when(
      //       data: (playlists) {
      //         return ListView.separated(
      //           itemBuilder: (context, index) {
      //             final playlist = playlists[index];
      //             return CustomTile(
      //               title: Text(playlist.title),
      //               leading: playlist.image != null
      //                   ? CachedNetworkImage(
      //                       imageUrl: playlist.image!,
      //                       height: 50,
      //                       width: 50,
      //                       memCacheHeight: 50,
      //                       memCacheWidth: 50,
      //                     )
      //                   : null,
      //               onTap: () {
      //                 if (playlist.type == PlaylistType.remote) {
      //                   if (playlist.provider == MusicProvider.ytmusic &&
      //                       playlist.endpoint != null) {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (_) =>
      //                             YtPlaylistScreen(body: playlist.endpoint!),
      //                       ),
      //                     );
      //                   }
      //                 }
      //               },
      //             );
      //           },
      //           separatorBuilder: (context, index) => SizedBox(height: 2),
      //           itemCount: playlists.length,
      //         );
      //       },
      //       error: (e, s) => Center(child: Text(e.toString())),
      //       loading: () => Center(child: CircularProgressIndicator()),
      //     ),
    );
  }
}
