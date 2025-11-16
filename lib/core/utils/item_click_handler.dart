import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/yt_music_base.dart';

void onSectionItemTap(BuildContext context, SectionItem item, {List<PlayableItem>? items}) async {
  if (item is PlayableItem) {
    if (item.provider == DataProvider.ytmusic) {
      await sl<MediaPlayer>().playSong(item);
      final songs = await sl<YTMusic>().getNextSongs(body: item.endpoint!);
      if (songs.isNotEmpty) {
        songs.removeAt(0);
        await sl<MediaPlayer>().addSongs(songs.whereType<PlayableItem>().toList());
      }
    } else {
      if (items != null) {
        await sl<MediaPlayer>().clearQueue();
        await sl<MediaPlayer>().addSongs(items);
        final index = items.indexOf(item);

        await sl<MediaPlayer>().skipToIndex(index);
        sl<MediaPlayer>().play();
      } else {
        await sl<MediaPlayer>().playSong(item);
      }
    }
    return;
  }
  final page = switch (item.type) {
    SectionItemType.playlist => 'playlist',

    SectionItemType.song => null,
    SectionItemType.video => null,
    SectionItemType.episode => null,
    SectionItemType.album => 'album',
    SectionItemType.artist => 'artist',
    SectionItemType.radioStation => null,
    SectionItemType.podcast => 'podcast',
    SectionItemType.button => null,
    SectionItemType.unknown => null,
  };
  if (page != null) {
    if (item.provider == DataProvider.ytmusic) {
      context.push('/ytmusic/$page/${jsonEncode(item.endpoint)}');
    } else {
      if (item.type == SectionItemType.album) {
        context.push('/jiosaavn/album/${item.id}');
      }
    }
    return;
  }
}
