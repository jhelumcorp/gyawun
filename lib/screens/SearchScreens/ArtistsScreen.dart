import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({required this.artists, super.key});
  final List artists;

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List artists = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    artists = widget.artists;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: artists.map(
        (artist) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8),
            onTap: () async {
              Navigator.pushNamed(context, '/search/artist', arguments: {
                'browseId': artist['browseId'],
                'imageUrl': artist['thumbnails'].last['url'],
                'name': artist['artist'],
              });
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(artist['thumbnails'].last['url']),
            ),
            title: Text(
              artist['artist'],
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleMedium
                  ?.copyWith(overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ).toList()),
    );
  }
}
