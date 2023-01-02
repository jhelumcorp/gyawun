import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: songs.map((track) {
          return TrackTile(
            track: track,
          );
        }).toList(),
      ),
    );
  }
}
