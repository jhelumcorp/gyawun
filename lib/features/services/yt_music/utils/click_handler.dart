import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/album/yt_album_screen.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/yt_playlist_screen.dart';
import 'package:ytmusic/models/yt_item.dart';

import '../podcast/yt_podcast_screen.dart';

void onYTSectionItemTap(BuildContext context, YTItem item) {
  if (item is YTPlaylist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YTPlaylistScreen(body: item.endpoint.cast()),
      ),
    );
  } else if (item is YTAlbum) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTAlbumScreen(body: item.endpoint.cast()),
      ),
    );
  } else if (item is YTArtist) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTArtistScreen(body: item.endpoint.cast()),
      ),
    );
  }
  if (item is YTPodcast) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTPodcastScreen(body: item.endpoint.cast()),
      ),
    );
  }
}
