import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/ThemeProvider.dart';

import '../generated/l10n.dart';
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
    bool isDarkTheme =
        context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
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
                    title: Text(
                      S.of(context).addToQueue,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box('myfavourites').listenable(),
                  builder: (context, Box box, child) {
                    Map? favourite = box.get(song.videoId);
                    return Material(
                      child: ListTile(
                        onTap: () {
                          if (favourite == null) {
                            int timeStamp =
                                DateTime.now().millisecondsSinceEpoch;
                            Map<String, dynamic> mapSong = song.toMap();
                            mapSong['timeStamp'] = timeStamp;

                            box.put(song.videoId, mapSong);
                          } else {
                            box.delete(song.videoId);
                          }
                          Navigator.pop(context);
                        },
                        title: Text(
                          favourite == null
                              ? S.of(context).Add_to_favorites
                              : S.of(context).Remove_from_favorites,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          });
    }

    return ListTile(
      onTap: () async {
        await context.read<MusicPlayer>().addNew(song);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${song.videoId}',
          width: 45,
          height: 45,
          fit: BoxFit.cover,
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
        showOptions(song);
      },
      trailing: IconButton(
          onPressed: () {
            showOptions(song);
          },
          icon: Icon(
            Icons.more_vert,
            color: isDarkTheme ? Colors.white : Colors.black,
          )),
    );
  }
}
