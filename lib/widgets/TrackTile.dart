import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/DownloadProvider.dart';
import 'package:vibe_music/providers/TD.dart';
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
        child: song.art != null
            ? Image.file(
                File(song.art!),
                width: 50,
                height: 50,
              )
            : Image.network(
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
  const DownloadTile(
      {Key? key,
      required this.tracks,
      this.index = 0,
      this.downloading = false})
      : super(key: key);

  final List tracks;
  final int index;
  final bool downloading;

  @override
  Widget build(BuildContext context) {
    Track? song = Track.fromMap(tracks[index]);
    List songs = tracks.sublist(index) + tracks.sublist(0, index);
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    ChunkedDownloader? dl =
        context.read<DownloadManager>().getManager(song.videoId);
    return ListTile(
      enableFeedback: false,
      onTap: () async {
        if (downloading) {
          if (dl != null) {
            dl.paused ? dl.resume() : dl.pause();
          }
        } else {
          context.read<MusicPlayer>().addPlayList(songs);
        }
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: tracks[index]?['art'] != null
            ? Image.file(
                File(tracks[index]['art']),
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              )
            : Image.network(
                song.thumbnails.first.url,
                width: 50,
                height: 50,
                fit: BoxFit.fill,
                errorBuilder: ((context, error, stackTrace) {
                  return Image.asset("assets/images/song.png");
                }),
              ),
      ),
      trailing: downloading
          ? (tracks[index]['status'] != 'done'
              ? Stack(
                  children: [
                    CircularProgressIndicator(
                      value: tracks[index]['progress'] != null
                          ? (tracks[index]['progress'] / 100)
                          : null,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      backgroundColor:
                          (isDarkTheme ? Colors.white : Colors.black)
                              .withOpacity(0.4),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        dl?.paused != null && dl!.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                )
              : null)
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
