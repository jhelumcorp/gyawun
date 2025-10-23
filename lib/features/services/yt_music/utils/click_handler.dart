import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/album/yt_album_screen.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/yt_playlist_screen.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/pretty_print.dart';

import '../podcast/yt_podcast_screen.dart';

void onYTSectionItemTap(BuildContext context, YTSectionItem item) {
  if (item.endpoint == null) {
    return;
  }
  if (item.type == YTSectionItemType.playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YTPlaylistScreen(body: item.endpoint!.cast()),
      ),
    );
  } else if (item.type == YTSectionItemType.album) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTAlbumScreen(body: item.endpoint!.cast()),
      ),
    );
  } else if (item.type == YTSectionItemType.artist) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTArtistScreen(body: item.endpoint!.cast()),
      ),
    );
  }
  if (item.type == YTSectionItemType.podcast) {
    Navigator.push(
      context,
       MaterialPageRoute(
        builder: (_) => YTPodcastScreen(body: item.endpoint!.cast()),
      ),
    );
  } else {
    pprint(item);
  }
}
