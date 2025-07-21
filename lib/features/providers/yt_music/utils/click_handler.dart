import 'package:flutter/cupertino.dart';
import 'package:gyawun_music/features/providers/yt_music/album/yt_album_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/yt_playlist_screen.dart';
import 'package:gyawun_music/features/providers/yt_music/podcast/yt_podcast_screen.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/pretty_print.dart';

void onYTSectionItemTap(BuildContext context, YTSectionItem item) {
  if (item.endpoint == null) {
    return;
  }
  if (item.type == YTSectionItemType.playlist) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => YtPlaylistScreen(body: item.endpoint!.cast()),
      ),
    );
  } else if (item.type == YTSectionItemType.album) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => YtAlbumScreen(body: item.endpoint!.cast()),
      ),
    );
  } else if (item.type == YTSectionItemType.artist) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => YtArtistScreen(body: item.endpoint!.cast()),
      ),
    );
  }
  if (item.type == YTSectionItemType.podcast) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => YtPodcastScreen(body: item.endpoint!.cast()),
      ),
    );
  } else {
    pprint(item);
  }
}
