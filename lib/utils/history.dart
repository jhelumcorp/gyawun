import 'package:get_it/get_it.dart';
import 'package:gyawun/utils/playback_cache.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> addSongHistory(Map song) async {
  bool isPlaybackCache =
      Hive.box('settings').get('playbackCache', defaultValue: false);

  Map? isDownloaded = Hive.box('downloads').get(song['id']);
  if (isPlaybackCache && isDownloaded == null) {
    bool isLocal =
        await GetIt.I<PlaybackCache>().existedInLocal(url: song['url']);
    if (!isLocal) {
      GetIt.I<PlaybackCache>().cacheFile(url: song['url']);
    }
  }
  bool isEnabled =
      Hive.box('settings').get('playbackHistory', defaultValue: true);
  if (!isEnabled) return;

  int i = await Hive.box('songHistory').get(song['id'])?['play_count'] ?? 0;
  i++;
  Map s = await Hive.box('songHistory').get(song['id']) ?? song;
  s['time_added'] = DateTime.now().millisecondsSinceEpoch;
  s['play_count'] = i;

  await Hive.box('songHistory').put(song['id'], s);
}
