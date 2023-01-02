import 'package:flutter/material.dart';
import 'package:vibe_music/generated/l10n.dart';

class PlaylistSearch extends StatefulWidget {
  const PlaylistSearch({required this.playlists, super.key});
  final List playlists;
  @override
  State<PlaylistSearch> createState() => _PlaylistSearchState();
}

class _PlaylistSearchState extends State<PlaylistSearch> {
  List playlists = [];

  @override
  void initState() {
    super.initState();
    playlists = widget.playlists;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        Map playlist = playlists[index];
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/search/playlist',
                arguments: {'playlistId': playlist['browseId']});
          },
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  playlist['thumbnails'].last['url'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                  errorBuilder: ((context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/playlist.png",
                      height: 100,
                      width: 100,
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                                overflow: TextOverflow.ellipsis, fontSize: 16),
                      ),
                      Text(
                        playlist['author'],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 93, 92, 92)),
                      ),
                      Text(
                        playlist['itemCount'] + ' ' + S.of(context).Songs,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 93, 92, 92)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



// Column(
//           children: [
//             Image.network(playlist['thumbnails'].last['url']),
//             Text(
//               playlist['title'],
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//             Text(
//               playlist['author'],
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         );,