import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/data/YTMusic/ytmusic.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen(
      {required this.playlistId, this.isAlbum = false, super.key});
  final String playlistId;
  final bool isAlbum;

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  Map? playlist;
  bool loading = true;
  @override
  void initState() {
    super.initState();

    if (widget.isAlbum) {
      HomeApi.getAlbum(widget.playlistId).then((Map value) {
        setState(() {
          playlist = value;

          playlist?['tracks']
              .removeWhere((element) => element['videoId'] == null);
          loading = false;
        });
      });
    } else {
      YTMUSIC.getPlaylistDetails(widget.playlistId).then((value) {
        setState(() {
          playlist = jsonDecode(jsonEncode(value));
          playlist?['tracks']
              .removeWhere((element) => element['videoId'] == null);
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: playlist == null || loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                // physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: playlist?['thumbnails'][
                                  (playlist?['thumbnails'].length / 2)
                                      .floor()]['url'],
                              width: (size.width / 2) - 24,
                              height: (size.width / 2) - 24,
                              errorWidget: ((context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/playlist.png",
                                  width: (size.width / 2) - 24,
                                  height: (size.width / 2) - 24,
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    playlist?['title'],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  Text(
                                    '${playlist?['tracks'].length} ${S.of(context).Songs}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                  Text(
                                    playlist?['author']?['name'] ??
                                        playlist?['artists']?.first['name'] ??
                                        "",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                  MaterialButton(
                                    textColor: Colors.white,
                                    color: Colors.black,
                                    onPressed: () async {
                                      await context
                                          .read<MusicPlayer>()
                                          .addPlayList(
                                            playlist?['tracks'],
                                          );
                                    },
                                    child: Text(S.of(context).Play_All),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        S.of(context).Tracks,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium
                            ?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (playlist != null)
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: playlist?['tracks'].length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> track =
                                playlist?['tracks'][index];
                            // if (track['videoId'] == null) {
                            //   playlist?['tracks'].remove(track);
                            //   setState(() {});
                            //   return const SizedBox.shrink();
                            // }
                            if (widget.isAlbum) {
                              track['thumbnails'] = [
                                {
                                  'url':
                                      'https://vibeapi-sheikh-haziq.vercel.app/thumb/sd?id=${track['videoId']}',
                                  'width': 60,
                                  'height': 60,
                                }
                              ];
                            }
                            return TrackTile(
                              track: track,
                            );
                          }),
                  ],
                ),
              ),
      ),
    );
  }
}
