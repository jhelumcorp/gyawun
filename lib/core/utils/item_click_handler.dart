import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/yt_music_base.dart';

void onSectionItemTap(BuildContext context, SectionItem item) async {
  if (item is PlayableItem) {
    await sl<MediaPlayer>().playSong(item);
    if (item.provider == DataProvider.ytmusic) {
      final songs = await sl<YTMusic>().getNextSongs(body: item.endpoint!);
      await sl<MediaPlayer>().addSongs(songs.whereType<PlayableItem>().toList().sublist(1));
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
