import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch({required this.songs, super.key});
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
                  title: Text(
                    S.of(context).addToQueue,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                            overflow: TextOverflow.ellipsis, fontSize: 16),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: songs.map((song) {
          return ListTile(
            onTap: () async {
              await context.read<MusicPlayer>().addNew(Track.fromMap(song));
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                'https://vibeapi-sheikh-haziq.vercel.app/thumb/sd?id=${song['videoId']}',
                errorBuilder: ((context, error, stackTrace) {
                  return Image.asset("assets/images/song.png");
                }),
              ),
            ),
            title: Text(
              song['title'],
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleMedium
                  ?.copyWith(overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(
              song['artists'].first['name'],
              style: const TextStyle(color: Color.fromARGB(255, 93, 92, 92)),
            ),
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
