import 'package:gyawun/api/api.dart';
import 'package:gyawun/api/ytmusic.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<List> getRecomendations() async {
  Box box = Hive.box('songHistory');
  List songs = box.values.toList();

  if (songs.isEmpty) return List.empty();

  songs.sort((a, b) => b['time_added'].compareTo(a['time_added']));
  songs.sort((a, b) => b['play_count'].compareTo(a['play_count']));
  String id = songs.first['id'];

  if (songs.first['provider'] == 'youtube') {
    return await YtMusicService()
        .getWatchPlaylist(videoId: id.replaceAll('youtube', ''));
  } else {
    return await SaavnAPI().getReco(id);
  }
}
