import 'package:hive_flutter/hive_flutter.dart';

Future<void> addSongHistory(Map song) async {
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
