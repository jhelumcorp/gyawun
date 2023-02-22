import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/utils/file.dart';

import '../providers/DownloadProvider.dart';

showOptions(Track song, context) {
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
                    Map? download = box.get(song.videoId);
                    return Material(
                      child: ListTile(
                        onTap: () {
                          if (download == null) {
                            context.read<DownloadManager>().download(song);
                          } else if (download['progress'] == 100) {
                            deleteFile(song.videoId);
                          }
                          Navigator.pop(context);
                        },
                        title: Text(
                          download == null
                              ? "Download"
                              : (download['progress'] < 100
                                  ? "Downloading"
                                  : "Delete"),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16),
                        ),
                        trailing: (download != null &&
                                download['progress'] < 100)
                            ? CircularProgressIndicator(
                                color:
                                    isDarkTheme ? Colors.white : Colors.black,
                                backgroundColor:
                                    (isDarkTheme ? Colors.white : Colors.black)
                                        .withOpacity(0.4),
                                value: download['progress'] / 100,
                              )
                            : null,
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
