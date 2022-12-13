import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:we_slide/we_slide.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch(
      {required this.songs, required this.weSlideController, super.key});
  final WeSlideController? weSlideController;
  final List songs;
  @override
  State<SongsSearch> createState() => _SongsSearchState();
}

class _SongsSearchState extends State<SongsSearch> {
  List songs = [];

  @override
  void initState() {
    super.initState();
    songs = widget.songs;
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
                    context.read<MusicPlayer>().addToQUeue(Track.fromMap(song));
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
    return SingleChildScrollView(
      child: Column(
        children: songs.map((song) {
          return ListTile(
            onTap: () async {
              await context
                  .read<MusicPlayer>()
                  .addNew(Track.fromMap(song), widget.weSlideController);
            },
            leading: Image.network(song['thumbnails'].first['url']),
            title: Text(
              song['title'],
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(song['artists'].first['name']),
            onLongPress: () {
              showOptions(song);
            },
            trailing: IconButton(
                onPressed: () {
                  showOptions(song);
                },
                icon: const Icon(Icons.more_vert)),
          );
        }).toList(),
      ),
    );
  }
}
