import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ytmusic/mixins/mixins.dart';
import 'package:ytmusic/ytmusic.dart';

import '../../features/services/yt_music/album/yt_album_screen.dart';
import 'modals.dart';

class ModalLayouts {
  static Widget itemBottomLayout(BuildContext context, YTItem item) {
    final isPlayable = item is YTSong || item is YTVideo || item is YTEpisode;
    final isHorizontal = (item is YTVideo || item is YTEpisode);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              item.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: (item as HasThumbnail).thumbnails.isEmpty
                ? null
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: item.thumbnails.first.url,
                      height: 50,
                      width: isHorizontal ? 80 : 50,
                    ),
                  ),
            subtitle: item.subtitle.isNotEmpty
                ? Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: isPlayable
                ? IconButton(
                    onPressed: () => {},
                    icon: const Icon(FluentIcons.heart_24_regular),
                  )
                : null,
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TopIconButton(
                      icon: FluentIcons.play_24_filled,
                      label: "Play Next",
                      onTap: () {
                        if (item is YTSong) {
                          sl<MyAudioHandler>().playNext(
                            MediaItem(
                              id: item.id.isNotEmpty
                                  ? item.id
                                  : jsonEncode(item.endpoint),
                              title: item.title,
                              album: item.album?.title,
                              artist: item.artists
                                  .map((e) => e.title)
                                  .join(', '),
                              artUri: item.thumbnails.lastOrNull?.url != null
                                  ? Uri.parse(item.thumbnails.last.url)
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                    TopIconButton(
                      icon: FluentIcons.task_list_add_24_filled,
                      label: "Add to queue",
                    ),
                    TopIconButton(
                      icon: FluentIcons.share_24_filled,
                      label: "Share",
                      onTap: () async {
                        // Your generated URL
                        final String url =
                            'https://music.youtube.com/${isPlayable ? 'watch?v' : 'playlist?list'}=${item.id}';

                        // 4. Call the instance method, just as you did,
                        //    but add the 'sharePositionOrigin' to the ShareParams.
                        await SharePlus.instance.share(
                          ShareParams(
                            text: url,
                            // THIS IS THE FIX:
                            // sharePositionOrigin: sharePositionOrigin,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (isPlayable)
                  ListTile(
                    title: Text(
                      "Add to Playlist",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(FluentIcons.document_one_page_add_24_filled),
                    onTap: () {
                      Navigator.pop(context);
                      // Modals.addToPlaylist(context, song);
                    },
                  ),
                if (isPlayable)
                  ListTile(
                    title: Text(
                      "Download",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(FluentIcons.cloud_arrow_down_24_filled),
                    onTap: () {
                      Navigator.pop(context);
                      // Modals.addToPlaylist(context, song);
                    },
                  ),
                ListTile(
                  title: Text(
                    "Start Radio",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Icon(FluentIcons.remix_add_24_filled),
                  onTap: () {
                    Navigator.pop(context);
                    // GetIt.I<MediaPlayer>().startRelated(Map.from(song), radio: true);
                  },
                ),
                if (item is HasArtists &&
                    (item as HasArtists).artists.isNotEmpty)
                  ListTile(
                    title: Text(
                      "Artists",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(FluentIcons.people_24_filled),
                    trailing: Icon(FluentIcons.chevron_right_24_filled),
                    onTap: () {
                      Navigator.pop(context);
                      Modals.showArtistsBottomSheet(
                        context,
                        (item as HasArtists).artists,
                      );
                    },
                  ),
                if (item is HasAlbum)
                  ListTile(
                    title: Text(
                      "Album",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Icon(FluentIcons.radio_button_24_filled),
                    trailing: Icon(FluentIcons.chevron_right_24_filled),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YTAlbumScreen(
                            body: (item as HasAlbum).album!.endpoint
                                .cast<String, dynamic>(),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget artistsBottomLayout(
    BuildContext context,
    List<YTArtistBasic> artists,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final artist in artists) ...[
              ListTile(
                title: Text(
                  artist.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(Icons.album),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YTArtistScreen(
                        body: artist.endpoint.cast<String, dynamic>(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TopIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;
  const TopIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon),
            SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
