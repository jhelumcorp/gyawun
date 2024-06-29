import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../ytmusic/ytmusic.dart';

Box _box = Hive.box('SETTINGS');

addHistory(Map song) async {
  if (_box.get('PLAYBACK_HISTORY', defaultValue: true)) {
    await addLocalHistory(song);
  }
  if (_box.get('PERSONALISED_CONTENT', defaultValue: true) &&
      song['status'] != 'DOWNLOADED') {
    GetIt.I<YTMusic>().addYoutubeHistory(song['videoId']);
  }
}

addLocalHistory(Map song) async {
  Box box = Hive.box('SONG_HISTORY');
  Map? oldState = box.get(song['videoId']);
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  if (oldState != null) {
    await box.put(song['videoId'],
        {...oldState, 'plays': oldState['plays'] + 1, 'updatedAt': timestamp});
  } else {
    await box.put(song['videoId'],
        {...song, 'plays': 1, 'CreatedAt': timestamp, 'updatedAt': timestamp});
  }
}
