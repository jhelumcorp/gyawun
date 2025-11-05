import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:ytmusic/models/yt_item.dart';

void onYTSectionItemTap(BuildContext context, YTItem item) {
  final page = item is YTPlaylist
      ? 'playlist'
      : item is YTAlbum
      ? 'album'
      : item is YTArtist
      ? 'artist'
      : item is YTPodcast
      ? 'podcast'
      : null;
  if (item is YTSong) {
    sl<MyAudioHandler>().playSong(
      MediaItem(
        id: item.id.isNotEmpty ? item.id : jsonEncode(item.endpoint),
        title: item.title,
        album: item.album?.title,
        artist: item.artists.map((e) => e.title).join(', '),
        artUri: item.thumbnails.lastOrNull?.url != null
            ? Uri.parse(item.thumbnails.last.url)
            : null,
      ),
    );
  }
  if (page == null) return;
  context.push('/home/$page/${jsonEncode(item.endpoint)}');
}
