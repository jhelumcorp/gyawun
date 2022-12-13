import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:we_slide/we_slide.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen(
      {required this.playlistId, required this.weSlideController, super.key});
  final WeSlideController weSlideController;
  final String playlistId;

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  Map? playlist;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    HomeApi.getPlaylist(widget.playlistId).then((Map value) {
      setState(() {
        log(widget.playlistId);
        log(value.toString());
        playlist = value;
        loading = false;
      });
    });
  }

  showOptions(song) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              Material(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<MusicPlayer>().addToQUeue(song);
                  },
                  title: const Text("Add to Queue"),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: playlist == null || loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              playlist?['thumbnails'][
                                  (playlist?['thumbnails'].length / 2)
                                      .floor()]['url'],
                              width: (size.width / 2) - 24,
                              height: (size.width / 2) - 24,
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text('${playlist?['trackCount']} songs'),
                                  Text(playlist?['author']['name']),
                                  MaterialButton(
                                    textColor: Colors.white,
                                    color: Colors.black,
                                    onPressed: () async {
                                      await context
                                          .read<MusicPlayer>()
                                          .addPlayList(playlist?['tracks'],
                                              widget.weSlideController);
                                    },
                                    child: const Text("PLAY ALL"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        "Tracks",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (playlist != null)
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: playlist?['tracks'].length,
                          itemBuilder: (context, index) {
                            Track? song =
                                Track.fromMap(playlist?['tracks'][index]);
                            // return SizedBox();
                            return ListTile(
                              onTap: () async {
                                await context
                                    .read<MusicPlayer>()
                                    .addNew(song, widget.weSlideController);
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  song.thumbnails.first.url,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Text(song.artists.first.name),
                              onLongPress: () {
                                showOptions(song);
                              },
                              trailing: IconButton(
                                  onPressed: () {
                                    showOptions(song);
                                    // showModalBottomSheet(
                                    //     useRootNavigator: true,
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return Column(
                                    //         children: [
                                    //           ListTile(
                                    //             onTap: () {
                                    //               Navigator.pop(context);
                                    //               context
                                    //                   .read<MusicPlayer>()
                                    //                   .addToQUeue(song);
                                    //             },
                                    //             title:
                                    //                 const Text("Add to Queue"),
                                    //           )
                                    //         ],
                                    //       );
                                    //     });
                                  },
                                  icon: const Icon(Icons.more_vert)),
                            );
                          }),
                  ],
                ),
              ),
      ),
    );
  }
}
