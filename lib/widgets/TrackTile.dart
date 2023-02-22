import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/DownloadProvider.dart';
import 'package:vibe_music/utils/showOptions.dart';

import '../providers/MusicPlayer.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Map<String, dynamic> track;

  @override
  Widget build(BuildContext context) {
    Track? song = Track.fromMap(track);

    return ListTile(
      enableFeedback: false,
      onTap: () async {
        await context.read<MusicPlayer>().addNew(song);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          song.thumbnails.first.url,
          width: 45,
          height: 45,
          fit: BoxFit.fill,
          errorBuilder: ((context, error, stackTrace) {
            return Image.asset("assets/images/song.png");
          }),
        ),
      ),
      title: Text(song.title,
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium
              ?.copyWith(overflow: TextOverflow.ellipsis)),
      subtitle: Text(
        song.artists.map((e) => e.name).toList().join(', '),
        style: const TextStyle(
          color: Color.fromARGB(255, 93, 92, 92),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onLongPress: () {
        showOptions(song, context);
      },
    );
  }
}

class DownloadTile extends StatelessWidget {
  const DownloadTile({Key? key, required this.tracks, this.index = 0})
      : super(key: key);

  final List tracks;
  final int index;

  @override
  Widget build(BuildContext context) {
    Track? song = Track.fromMap(tracks[index]);
    List songs = tracks.sublist(index) + tracks.sublist(0, index);
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      enableFeedback: false,
      onTap: () async {
        context.read<MusicPlayer>().addPlayList(songs);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          song.thumbnails.first.url,
          width: 45,
          height: 45,
          fit: BoxFit.fill,
          errorBuilder: ((context, error, stackTrace) {
            return Image.asset("assets/images/song.png");
          }),
        ),
      ),
      trailing: tracks[index]['status'] != 'done'
          ? CircularProgressIndicator(
              value: (tracks[index]['progress'] ?? 0.00) / 100,
              color: isDarkTheme ? Colors.white : Colors.black,
              backgroundColor:
                  (isDarkTheme ? Colors.white : Colors.black).withOpacity(0.4),
            )
          : null,
      title: Text(song.title,
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium
              ?.copyWith(overflow: TextOverflow.ellipsis)),
      subtitle: Text(
        song.artists.map((e) => e.name).toList().join(', '),
        style: const TextStyle(
          color: Color.fromARGB(255, 93, 92, 92),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onLongPress: () {
        showOptions(song, context);
      },
    );
  }
}
