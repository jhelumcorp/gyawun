import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:ytmusic/models/yt_item.dart';

void onYTSectionItemTap(BuildContext context, YTItem item) async {
  final page = item is YTPlaylist
      ? 'playlist'
      : item is YTAlbum
      ? 'album'
      : item is YTArtist
      ? 'artist'
      : item is YTPodcast
      ? 'podcast'
      : null;
  if (page != null) {
    context.push('/$page/${jsonEncode(item.endpoint)}');
    return;
  }
  await sl<MediaPlayer>().playYTSong(item);
}
