import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/artist/yt_artist_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/ytmusic.dart';

import 'modals.dart';

class ModalLayouts {
  static Widget itemBottomLayout(BuildContext context, YTSectionItem item) {
    final isPlayable = [
      YTSectionItemType.song,
      YTSectionItemType.video,
      YTSectionItemType.episode,
    ].contains(item.type);
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.thumbnails.first.url,
              height: 50,
              width: item.type == YTSectionItemType.video ? 80 : 50,
            ),
          ),
          subtitle: item.subtitle != null
              ? Text(
                  item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isPlayable
              ? IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.favorite),
                )
              : null,
        ),
        Divider(height: 1),
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TopIconButton(
                        icon: Icons.queue_play_next_rounded,
                        label: "Play Next",
                        onTap: () {},
                      ),
                      TopIconButton(
                        icon: Icons.add_to_queue,
                        label: "Add to queue",
                      ),
                      TopIconButton(
                        icon: Icons.share,
                        label: "Share",
                        onTap: () => SharePlus.instance.share(
                          ShareParams(
                            uri: Uri.parse(
                              'https://music.youtube.com/${isPlayable? 'watch?v':'playlist?list'}=${item.id}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isPlayable)
                    ListTile(
                      title: Text("Add to Playlist"),
                      leading: Icon(Icons.library_add),
                      onTap: () {
                        Navigator.pop(context);
                        // Modals.addToPlaylist(context, song);
                      },
                    ),
                  if (isPlayable)
                    ListTile(
                      title: Text("Download"),
                      leading: Icon(Icons.cloud_download_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        // Modals.addToPlaylist(context, song);
                      },
                    ),
                  ListTile(
                    title: Text("Start Radio"),
                    leading: Icon(Icons.radio),
                    onTap: () {
                      Navigator.pop(context);
                      // GetIt.I<MediaPlayer>().startRelated(Map.from(song), radio: true);
                    },
                  ),
                  if (item.artists.isNotEmpty)
                    ListTile(
                      title: Text("Artists"),
                      leading: Icon(Icons.people),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        Modals.showArtistsBottomSheet(context, item.artists);
                      },
                    ),
                  if (item.album != null)
                    ListTile(
                      title: Text(
                        "Album",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Icon(Icons.album),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => YtAlbumScreen(
                        //       body: item.album!.endpoint
                        //           .cast<String, dynamic>(),
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget artistsBottomLayout(
    BuildContext context,
    List<YTArtist> artists,
  ) {
    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
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
        );
      },
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
      onTap: () => onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [Icon(icon), Text(label)]),
      ),
    );
  }
}
