import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/providers/TD.dart';
import 'package:vibe_music/utils/file.dart';

import '../providers/DownloadProvider.dart';

showOptions(Track song, context) {
  bool darkTheme = Theme.of(context).brightness == Brightness.dark;
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, Box box, child) {
            bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
            return CupertinoActionSheet(
              actions: [
                Material(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        'https://vibeapi-sheikh-haziq.vercel.app/thumb/sd?id=${song.videoId}',
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
                    trailing: IconButton(
                        onPressed: () {
                          Share.share(
                              "https://music.youtube.com/watch?v=${song.videoId}");
                        },
                        icon: Icon(
                          Icons.share,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        )),
                  ),
                ),
                Material(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<MusicPlayer>().playNext(song);
                    },
                    title: Text(
                      S.of(context).Play_next,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                    ),
                  ),
                ),
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
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box('downloads').listenable(),
                  builder: (context, Box box, child) {
                    ChunkedDownloader? dl = context
                        .watch<DownloadManager>()
                        .getManager(song.videoId);
                    Map? item =
                        context.watch<DownloadManager>().getSong(song.videoId);
                    Map? download = box.get(song.videoId);
                    return Material(
                      child: ListTile(
                        onTap: () {
                          if (download != null) {
                            deleteFile(song.videoId);
                          } else if (dl == null) {
                            context.read<DownloadManager>().download(song);
                          } else {
                            if (dl.paused) {
                              dl.resume();
                            } else {
                              dl.pause();
                            }
                          }
                        },
                        title: Text(
                          download != null
                              ? "Delete"
                              : (dl == null
                                  ? "Download"
                                  : (dl.paused ? "Resume" : "Pause")),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16),
                        ),
                        trailing: download != null
                            ? Icon(
                                Icons.delete,
                                color: darkTheme ? Colors.white : Colors.black,
                              )
                            : (item == null
                                ? null
                                : Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          dl != null && dl.paused
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                          color: darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      CircularProgressIndicator(
                                        value: item['progress'] != null
                                            ? (item['progress'] / 100)
                                            : null,
                                        color: darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        backgroundColor: (darkTheme
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(0.4),
                                      )
                                    ],
                                  )),
                      ),
                    );
                  },
                )
              ],
            );
          },
        );
      });
}
