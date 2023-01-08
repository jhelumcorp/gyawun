import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe_music/Models/Artist.dart';
import 'package:vibe_music/Models/Thumbnail.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/HomeScreenProvider.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/utils/showOptions.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  List trending = [];
  List? artists = [];
  List? head = [];
  List? body = [];
  bool isLoading = true;
  PageController songsController = PageController(
    viewportFraction: 0.9,
  );
  @override
  void initState() {
    super.initState();
    HomeApi().getMusicHome().then((value) {
      setState(() {
        head = value['head'];
        body = value['body'];
      });
    });
    HomeApi.getCharts().then((value) {
      trending = value['trending'];
      artists = value['artists'];
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vibe Music"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (head != null)
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                enlargeCenterPage: true,
                              ),
                              items: head!.map((s) {
                                Track song = Track(
                                  title: s['title'],
                                  videoId: s['videoId'],
                                  artists: [],
                                  thumbnails: [Thumbnail(url: s['image'])],
                                );
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await context
                                              .read<MusicPlayer>()
                                              .addNew(
                                                song,
                                              );
                                        },
                                        onLongPress: () {
                                          showOptions(song, context);
                                        },
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  'https://img.youtube.com/vi/${song.videoId}/maxresdefault.jpg',
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              alignment: Alignment.bottomLeft,
                                              child: ListTile(
                                                onTap: () async {
                                                  await context
                                                      .read<MusicPlayer>()
                                                      .addNew(
                                                        song,
                                                      );
                                                },
                                                title: Text(
                                                  song.title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                trailing: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      await context
                                                          .read<MusicPlayer>()
                                                          .addNew(
                                                            song,
                                                          );
                                                    },
                                                    icon: const Icon(Icons
                                                        .play_arrow_rounded)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          // CarouselSlider(
                          //   options: CarouselOptions(
                          //     aspectRatio: 16 / 9,
                          //     enableInfiniteScroll: true,
                          //     autoPlay: true,
                          //     enlargeCenterPage: true,
                          //   ),
                          //   items: trending
                          //       .sublist(0,
                          //           trending.length > 10 ? 10 : trending.length)
                          //       .map((s) {
                          //     Track song = Track.fromMap(s);
                          //     return Builder(
                          //       builder: (BuildContext context) {
                          //         return ClipRRect(
                          //           borderRadius: BorderRadius.circular(10),
                          //           child: GestureDetector(
                          //             onTap: () async {
                          //               await context
                          //                   .read<MusicPlayer>()
                          //                   .addNew(
                          //                     song,
                          //                   );
                          //             },
                          //             onLongPress: () {
                          //               showOptions(song);
                          //             },
                          //             child: Stack(
                          //               children: [
                          //                 CachedNetworkImage(
                          //                   imageUrl:
                          //                       'https://img.youtube.com/vi/${song.videoId}/maxresdefault.jpg',
                          //                   fit: BoxFit.fill,
                          //                   width: double.infinity,
                          //                   height: double.infinity,
                          //                 ),
                          //                 Container(
                          //                   decoration: const BoxDecoration(
                          //                     gradient: LinearGradient(
                          //                       colors: [
                          //                         Colors.transparent,
                          //                         Colors.black
                          //                       ],
                          //                       begin: Alignment.topCenter,
                          //                       end: Alignment.bottomCenter,
                          //                     ),
                          //                   ),
                          //                   alignment: Alignment.bottomLeft,
                          //                   child: ListTile(
                          //                     onTap: () async {
                          //                       await context
                          //                           .read<MusicPlayer>()
                          //                           .addNew(
                          //                             song,
                          //                           );
                          //                     },
                          //                     title: Text(
                          //                       song.title,
                          //                       style: const TextStyle(
                          //                           color: Colors.white,
                          //                           overflow:
                          //                               TextOverflow.ellipsis),
                          //                     ),
                          //                     trailing: IconButton(
                          //                         color: Colors.white,
                          //                         onPressed: () async {
                          //                           await context
                          //                               .read<MusicPlayer>()
                          //                               .addNew(
                          //                                 song,
                          //                               );
                          //                         },
                          //                         icon: const Icon(Icons
                          //                             .play_arrow_rounded)),
                          //                   ),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     );
                          //   }).toList(),
                          // ),
                          if (artists != null && artists!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 16),
                              child: Text(
                                S.of(context).Artists,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          if (artists != null && artists!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: artists!.map((artist) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/home/artist',
                                                arguments: {
                                                  'browseId':
                                                      artist['browseId'],
                                                  'imageUrl':
                                                      artist['thumbnails']
                                                          .last['url'],
                                                  'name': artist['title'],
                                                });
                                          },
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                    artist['thumbnails']
                                                        .last['url']),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                artist['title'],
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                            ),
                          if (body != null && body!.isNotEmpty)
                            ...body!.map((item) {
                              String title = item['title'];
                              List content = item['playlists'] as List;
                              bool areSongs = content.first['videoId'] != null;
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 8.0, bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if (!areSongs)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Text(
                                        title,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (areSongs)
                                      ExpandablePageView(
                                        controller: songsController,
                                        padEnds: false,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: content
                                                  .sublist(
                                                      0,
                                                      content.length > 4
                                                          ? 4
                                                          : content.length)
                                                  .map((track) {
                                                track['artists'] = [
                                                  Artist(name: track['count'])
                                                      .toMap()
                                                ];
                                                track['thumbnails'] = [
                                                  Thumbnail(url: track['image'])
                                                      .toMap()
                                                ];
                                                return TrackTile(track: track);
                                              }).toList()),
                                          if (content.length > 4)
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: content
                                                    .sublist(
                                                        4,
                                                        content.length > 8
                                                            ? 8
                                                            : content.length)
                                                    .map((track) {
                                                  track['artists'] = [
                                                    Artist(name: track['count'])
                                                        .toMap()
                                                  ];
                                                  track['thumbnails'] = [
                                                    Thumbnail(
                                                            url: track['image'])
                                                        .toMap()
                                                  ];
                                                  return TrackTile(
                                                      track: track);
                                                }).toList()),
                                          if (content.length > 8)
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: content
                                                    .sublist(
                                                        8,
                                                        content.length > 12
                                                            ? 12
                                                            : content.length)
                                                    .map((track) {
                                                  track['artists'] = [
                                                    Artist(name: track['count'])
                                                        .toMap()
                                                  ];
                                                  track['thumbnails'] = [
                                                    Thumbnail(
                                                            url: track['image'])
                                                        .toMap()
                                                  ];
                                                  return TrackTile(
                                                      track: track);
                                                }).toList()),
                                          if (content.length > 12)
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: content
                                                    .sublist(
                                                        12,
                                                        content.length > 16
                                                            ? 16
                                                            : content.length)
                                                    .map((track) {
                                                  track['artists'] = [
                                                    Artist(name: track['count'])
                                                        .toMap()
                                                  ];
                                                  track['thumbnails'] = [
                                                    Thumbnail(
                                                            url: track['image'])
                                                        .toMap()
                                                  ];
                                                  return TrackTile(
                                                      track: track);
                                                }).toList()),
                                        ],
                                      ),
                                    if (!areSongs)
                                      SizedBox(
                                        height: 150,
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: content.length,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 10);
                                          },
                                          itemBuilder: (context, index) {
                                            Map playlist =
                                                content[index] as Map;

                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/playlist',
                                                      arguments: {
                                                        'playlistId': playlist[
                                                                'playlistId'] ??
                                                            playlist[
                                                                'browseId'],
                                                        'isAlbum': playlist[
                                                                'browseId'] !=
                                                            null,
                                                      });
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: playlist['image'],
                                                  errorWidget: ((context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                        "assets/images/playlist.png");
                                                  }),
                                                  height: 150,
                                                  // width: 150,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                  ],
                                ),
                              );
                            }).toList()
                          // ...context
                          //     .watch<HomeScreenProvider>()
                          //     .getData
                          //     .map((item) {
                          //   String title = item['title'];
                          //   List content = item['contents'] as List;
                          //   bool areSongs = content.first['videoId'] != null;
                          //   return Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 0, top: 8.0, bottom: 8.0),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         // if (!areSongs)
                          //         Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 8, horizontal: 8),
                          //           child: Text(
                          //             title,
                          //             style: Theme.of(context)
                          //                 .primaryTextTheme
                          //                 .titleLarge
                          //                 ?.copyWith(
                          //                   fontSize: 24,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //           ),
                          //         ),
                          //         if (areSongs)
                          //           ExpandablePageView(
                          //             controller: songsController,
                          //             padEnds: false,
                          //             children: [
                          //               Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: content
                          //                       .sublist(
                          //                           0,
                          //                           content.length > 4
                          //                               ? 4
                          //                               : content.length)
                          //                       .map((track) {
                          //                     return TrackTile(track: track);
                          //                   }).toList()),
                          //               if (content.length > 4)
                          //                 Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: content
                          //                         .sublist(
                          //                             4,
                          //                             content.length > 8
                          //                                 ? 8
                          //                                 : content.length)
                          //                         .map((track) {
                          //                       return TrackTile(track: track);
                          //                     }).toList()),
                          //               if (content.length > 8)
                          //                 Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: content
                          //                         .sublist(
                          //                             8,
                          //                             content.length > 12
                          //                                 ? 12
                          //                                 : content.length)
                          //                         .map((track) {
                          //                       return TrackTile(track: track);
                          //                     }).toList()),
                          //               if (content.length > 12)
                          //                 Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: content
                          //                         .sublist(
                          //                             12,
                          //                             content.length > 16
                          //                                 ? 16
                          //                                 : content.length)
                          //                         .map((track) {
                          //                       return TrackTile(track: track);
                          //                     }).toList()),
                          //               if (content.length > 16)
                          //                 Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: content
                          //                         .sublist(
                          //                             16,
                          //                             content.length > 20
                          //                                 ? 20
                          //                                 : content.length)
                          //                         .map((track) {
                          //                       return TrackTile(track: track);
                          //                     }).toList()),
                          //             ],
                          //           ),
                          //         if (!areSongs)
                          //           SizedBox(
                          //             height: 150,
                          //             child: ListView.separated(
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: 16),
                          //               shrinkWrap: true,
                          //               scrollDirection: Axis.horizontal,
                          //               itemCount: content.length,
                          //               separatorBuilder: (context, index) {
                          //                 return const SizedBox(width: 10);
                          //               },
                          //               itemBuilder: (context, index) {
                          //                 Map playlist = content[index] as Map;

                          //                 return ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                   child: InkWell(
                          //                     onTap: () {
                          //                       Navigator.pushNamed(
                          //                           context, '/playlist',
                          //                           arguments: {
                          //                             'playlistId': playlist[
                          //                                     'playlistId'] ??
                          //                                 playlist['browseId'],
                          //                             'isAlbum': playlist[
                          //                                     'browseId'] !=
                          //                                 null,
                          //                           });
                          //                     },
                          //                     child: CachedNetworkImage(
                          //                       imageUrl: playlist['thumbnails']
                          //                           .last['url'],
                          //                       errorWidget: ((context, error,
                          //                           stackTrace) {
                          //                         return Image.asset(
                          //                             "assets/images/playlist.png");
                          //                       }),
                          //                       height: 150,
                          //                       width: 150,
                          //                       fit: BoxFit.contain,
                          //                     ),
                          //                   ),
                          //                 );
                          //               },
                          //             ),
                          //           )
                          //       ],
                          //     ),
                          //   );
                          // }).toList()
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
