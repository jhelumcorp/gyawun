import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/HomeScreenProvider.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
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
  PageController songsController = PageController(
    viewportFraction: 0.9,
  );
  @override
  void initState() {
    super.initState();

    HomeApi.getCharts().then((value) {
      trending = value['trending'];
      artists = value['artists'];
      setState(() {});
    });
    HomeApi.getHome().then((List value) {
      context.read<HomeScreenProvider>().addData(value);
    });
  }

  showOptions(song) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              Material(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<MusicPlayer>().addToQUeue(song);
                  },
                  title: Text(
                    S.of(context).addToQueue,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(
                            overflow: TextOverflow.ellipsis, fontSize: 16),
                  ),
                ),
              )
            ],
          );
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
        child: context.watch<HomeScreenProvider>().isLoading
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
                          CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items: trending
                                .sublist(0,
                                    trending.length > 10 ? 10 : trending.length)
                                .map((s) {
                              Track song = Track.fromJson(jsonEncode(s));
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
                                        showOptions(song);
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
                                                    overflow:
                                                        TextOverflow.ellipsis),
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
                          ...context
                              .watch<HomeScreenProvider>()
                              .getData
                              .map((item) {
                            String title = item['title'];
                            List content = item['contents'] as List;
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
                                  // if (areSongs)
                                  //   Column(
                                  //       children:
                                  //           content.sublist(0, 5).map((track) {
                                  //     return TrackTile(track: track);
                                  //   }).toList()),
                                  if (areSongs)
                                    ExpandablePageView(
                                      controller: songsController,
                                      padEnds: false,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: content
                                                .sublist(0, 5)
                                                .map((track) {
                                              return TrackTile(track: track);
                                            }).toList()),
                                        if (content.length > 5)
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: content
                                                  .sublist(
                                                      5,
                                                      content.length > 10
                                                          ? 10
                                                          : content.length)
                                                  .map((track) {
                                                return TrackTile(track: track);
                                              }).toList()),
                                        if (content.length > 10)
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: content
                                                  .sublist(
                                                      10,
                                                      content.length > 15
                                                          ? 15
                                                          : content.length)
                                                  .map((track) {
                                                return TrackTile(track: track);
                                              }).toList()),
                                        if (content.length > 15)
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: content
                                                  .sublist(
                                                      15,
                                                      content.length > 20
                                                          ? 20
                                                          : content.length)
                                                  .map((track) {
                                                return TrackTile(track: track);
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
                                          Map playlist = content[index] as Map;

                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/playlist',
                                                    arguments: {
                                                      'playlistId':
                                                          playlist['playlistId']
                                                    });
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: playlist['thumbnails']
                                                    .last['url'],
                                                errorWidget: ((context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      "assets/images/playlist.png");
                                                }),
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.contain,
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
