import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
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
      onTap: () async {
        await context.read<MusicPlayer>().addNew(song);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          // 'https://vibeapi-sheikh-haziq.vercel.app/thumb/sd?id=${song.videoId}',
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
