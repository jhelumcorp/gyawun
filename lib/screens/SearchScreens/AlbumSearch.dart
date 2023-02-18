import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/SearchProvider.dart';

class AlbumSearch extends StatefulWidget {
  const AlbumSearch({this.query = "", super.key});
  final String query;
  @override
  State<AlbumSearch> createState() => _AlbumSearchState();
}

class _AlbumSearchState extends State<AlbumSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SearchProvider>().searchAlbums(widget.query);
    return !context.watch<SearchProvider>().albumsLoaded
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: context.watch<SearchProvider>().albums.length,
            itemBuilder: (context, index) {
              Map album = context.watch<SearchProvider>().albums[index];
              return ListTile(
                enableFeedback: false,
                onTap: () {
                  Navigator.pushNamed(context, '/playlist', arguments: {
                    'playlistId': album['browseId'],
                    'isAlbum': true
                  });
                },
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        album['thumbnails'].last['url'],
                        height: 60,
                        width: 60,
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
                              album['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16),
                            ),
                            if (album['artists'].isNotEmpty)
                              Text(
                                album['artists'].first['name'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 93, 92, 92)),
                              )
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
