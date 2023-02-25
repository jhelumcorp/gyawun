// import 'dart:developer';

import 'dart:convert';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/Models/Artist.dart';
import 'package:vibe_music/Models/HomeModel.dart';
import 'package:vibe_music/Models/Thumbnail.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/SearchScreen.dart';

import 'package:vibe_music/screens/SettingsScreen.dart';
import 'package:vibe_music/utils/connectivity.dart';
import 'package:vibe_music/utils/navigator.dart';
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
  List? head = [];
  List<HomeModel> body = [];
  List recommendations = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isConnectivity().then((value) {
      if (value) {
        getHomeData();
      }
    });
  }

  Future getHomeData() async {
    bool connected = await isConnectivity();
    if (!connected) {
      return;
    }
    Map home = await HomeApi().getMusicHome();
    List recommend = await getRelated();
    setState(() {
      head = home['head'];
      body = home['body'];
      recommendations = recommend;
      isLoading = false;
    });
  }

  getRelated() async {
    List boxList = Hive.box('song_history').values.toList();
    if (boxList.isEmpty) {
      return List.empty();
    }
    boxList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    List newList =
        boxList.getRange(0, boxList.length > 20 ? 20 : boxList.length).toList();
    newList.sort((a, b) => b['hits'].compareTo(a['hits']));
    math.Random rand = math.Random();
    int index = rand.nextInt(newList.length > 10 ? 10 : boxList.length);
    return await HomeApi.getWatchPlaylist(boxList[index]['videoId'], 20);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: isConnectivity(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !(snapshot.data!)) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection",
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          getHomeData();
                        },
                        child: const Text("RETRY"),
                      ),
                    ],
                  ),
                );
              }
              return isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (darkTheme ? Colors.white : Colors.black)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const SearchScreen()));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.search_rounded,
                                    size: 26,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SearchScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Vibe Music",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: (darkTheme
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  mainNavigatorKey.currentState!.push(
                                    CupertinoPageRoute(
                                      builder: (_) => const SettingsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  size: 26,
                                ),
                                color: darkTheme ? Colors.white : Colors.black,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: getHomeData,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(top: 8),
                              child: SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                thumbnails: [
                                                  Thumbnail(url: s['image'])
                                                ],
                                              );
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await context
                                                            .read<MusicPlayer>()
                                                            .addNew(
                                                              song,
                                                            );
                                                      },
                                                      onLongPress: () {
                                                        showOptions(
                                                            song, context);
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            'https://img.youtube.com/vi/${song.videoId}/maxresdefault.jpg',
                                                        fit: BoxFit.fill,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: ValueListenableBuilder(
                                            valueListenable:
                                                Hive.box('song_history')
                                                    .listenable(),
                                            builder: (context, Box box, child) {
                                              List values = box.values.toList();
                                              values.sort((a, b) =>
                                                  b["timestamp"].compareTo(
                                                      a["timestamp"]));

                                              return values.isEmpty
                                                  ? const SizedBox.shrink()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .Recently_played,
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .titleLarge
                                                                ?.copyWith(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 210,
                                                          child: ListView
                                                              .separated(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                values.length,
                                                            separatorBuilder:
                                                                (context,
                                                                    index) {
                                                              return const SizedBox(
                                                                  width: 10);
                                                            },
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              Map<String,
                                                                      dynamic>
                                                                  item =
                                                                  jsonDecode(jsonEncode(
                                                                      values.toList()[
                                                                          index]));
                                                              Track track =
                                                                  Track.fromMap(
                                                                      item);

                                                              return InkWell(
                                                                onLongPress:
                                                                    () {
                                                                  showOptions(
                                                                      track,
                                                                      context);
                                                                },
                                                                onTap: () {
                                                                  context
                                                                      .read<
                                                                          MusicPlayer>()
                                                                      .addNew(
                                                                          track);
                                                                },
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    color: (darkTheme
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black)
                                                                        .withOpacity(
                                                                            0.2),
                                                                    width: 150,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CachedNetworkImage(
                                                                          imageUrl:
                                                                              'https://vibeapi-sheikh-haziq.vercel.app/thumb/hd?id=${track.videoId}',
                                                                          height:
                                                                              150,
                                                                          width:
                                                                              150,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text(
                                                                            '${track.title} - ${track.artists.map((e) => e.name).toList().join(', ')}',
                                                                            maxLines:
                                                                                2,
                                                                            style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            },
                                          ),
                                        ),
                                        if (recommendations.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: Text(
                                                  S.of(context).Recommended,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              ExpandablePageView(
                                                controller: PageController(
                                                  initialPage: 0,
                                                  viewportFraction: 0.9,
                                                ),
                                                padEnds: false,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: recommendations
                                                          .sublist(
                                                              0,
                                                              recommendations
                                                                          .length >
                                                                      4
                                                                  ? 4
                                                                  : recommendations
                                                                      .length)
                                                          .map((track) {
                                                        track['thumbnails'] =
                                                            track['thumbnail'];
                                                        return TrackTile(
                                                            track: track);
                                                      }).toList()),
                                                  if (recommendations.length >
                                                      4)
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: recommendations
                                                            .sublist(
                                                                4,
                                                                recommendations
                                                                            .length >
                                                                        8
                                                                    ? 8
                                                                    : recommendations
                                                                        .length)
                                                            .map((track) {
                                                          track['thumbnails'] =
                                                              track[
                                                                  'thumbnail'];
                                                          return TrackTile(
                                                              track: track);
                                                        }).toList()),
                                                  if (recommendations.length >
                                                      8)
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: recommendations
                                                            .sublist(
                                                                8,
                                                                recommendations
                                                                            .length >
                                                                        12
                                                                    ? 12
                                                                    : recommendations
                                                                        .length)
                                                            .map((track) {
                                                          track['thumbnails'] =
                                                              track[
                                                                  'thumbnail'];
                                                          return TrackTile(
                                                              track: track);
                                                        }).toList()),
                                                  if (recommendations.length >
                                                      12)
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: recommendations
                                                            .sublist(
                                                                12,
                                                                recommendations
                                                                            .length >
                                                                        16
                                                                    ? 16
                                                                    : recommendations
                                                                        .length)
                                                            .map((track) {
                                                          track['thumbnails'] =
                                                              track[
                                                                  'thumbnail'];
                                                          return TrackTile(
                                                              track: track);
                                                        }).toList())
                                                ],
                                              ),
                                            ],
                                          ),
                                        if (body != null && body.isNotEmpty)
                                          ...body.map((item) {
                                            String title = item.title;
                                            List content = item.playlists;
                                            bool areSongs = content.isNotEmpty
                                                ? content.first['videoId'] !=
                                                    null
                                                : false;

                                            return content.isEmpty
                                                ? const SizedBox.shrink()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            top: 8.0,
                                                            bottom: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            title,
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .titleLarge
                                                                ?.copyWith(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                        if (areSongs)
                                                          ExpandablePageView(
                                                            controller:
                                                                PageController(
                                                              initialPage: 0,
                                                              viewportFraction:
                                                                  0.9,
                                                            ),
                                                            padEnds: false,
                                                            children: [
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: content
                                                                      .sublist(
                                                                          0,
                                                                          content.length > 4
                                                                              ? 4
                                                                              : content.length)
                                                                      .map((track) {
                                                                    track['artists'] =
                                                                        [
                                                                      Artist(name: track['count'])
                                                                          .toMap()
                                                                    ];
                                                                    track['thumbnails'] =
                                                                        [
                                                                      Thumbnail(
                                                                              url: track['image'])
                                                                          .toMap()
                                                                    ];
                                                                    return TrackTile(
                                                                        track:
                                                                            track);
                                                                  }).toList()),
                                                              if (content
                                                                      .length >
                                                                  4)
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: content
                                                                        .sublist(
                                                                            4,
                                                                            content.length > 8
                                                                                ? 8
                                                                                : content.length)
                                                                        .map((track) {
                                                                      track['artists'] =
                                                                          [
                                                                        Artist(name: track['count'])
                                                                            .toMap()
                                                                      ];
                                                                      track['thumbnails'] =
                                                                          [
                                                                        Thumbnail(url: track['image'])
                                                                            .toMap()
                                                                      ];
                                                                      return TrackTile(
                                                                          track:
                                                                              track);
                                                                    }).toList()),
                                                              if (content
                                                                      .length >
                                                                  8)
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: content
                                                                        .sublist(
                                                                            8,
                                                                            content.length > 12
                                                                                ? 12
                                                                                : content.length)
                                                                        .map((track) {
                                                                      track['artists'] =
                                                                          [
                                                                        Artist(name: track['count'])
                                                                            .toMap()
                                                                      ];
                                                                      track['thumbnails'] =
                                                                          [
                                                                        Thumbnail(url: track['image'])
                                                                            .toMap()
                                                                      ];
                                                                      return TrackTile(
                                                                          track:
                                                                              track);
                                                                    }).toList()),
                                                              if (content
                                                                      .length >
                                                                  12)
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: content
                                                                        .sublist(
                                                                            12,
                                                                            content.length > 16
                                                                                ? 16
                                                                                : content.length)
                                                                        .map((track) {
                                                                      track['artists'] =
                                                                          [
                                                                        Artist(name: track['count'])
                                                                            .toMap()
                                                                      ];
                                                                      track['thumbnails'] =
                                                                          [
                                                                        Thumbnail(url: track['image'])
                                                                            .toMap()
                                                                      ];
                                                                      return TrackTile(
                                                                          track:
                                                                              track);
                                                                    }).toList()),
                                                            ],
                                                          ),
                                                        if (!areSongs)
                                                          SizedBox(
                                                            height: 150,
                                                            child: ListView
                                                                .separated(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: content
                                                                  .length,
                                                              separatorBuilder:
                                                                  (context,
                                                                      index) {
                                                                return const SizedBox(
                                                                    width: 10);
                                                              },
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                Map playlist =
                                                                    content[index]
                                                                        as Map;

                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          '/playlist',
                                                                          arguments: {
                                                                            'playlistId':
                                                                                playlist['playlistId'] ?? playlist['browseId'],
                                                                            'isAlbum':
                                                                                playlist['browseId'] != null,
                                                                          });
                                                                    },
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          playlist[
                                                                              'image'],
                                                                      errorWidget: ((context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image.asset(
                                                                            "assets/images/playlist.png");
                                                                      }),
                                                                      height:
                                                                          150,
                                                                      // width: 150,
                                                                      fit: BoxFit
                                                                          .fitHeight,
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
                        ),
                      ],
                    );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
