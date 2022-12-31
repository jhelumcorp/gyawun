import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/HomeScreenProvider.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';

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
  @override
  void initState() {
    super.initState();

    HomeApi.getCharts().then((value) {
      trending = value['items'];
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
                                          Image.network(
                                            song.thumbnails.first.url,
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
                          ...context
                              .watch<HomeScreenProvider>()
                              .getData
                              .map((item) {
                            String title = item['title'];
                            log(title);
                            List content = item['contents'] as List;
                            bool areSongs = content.first['videoId'] != null;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!areSongs)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        S.of(context).quickPicks,
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
                                    Column(
                                        children:
                                            content.sublist(0, 5).map((s) {
                                      Track song =
                                          Track.fromJson(jsonEncode(s));
                                      return ListTile(
                                        onTap: () async {
                                          await context
                                              .read<MusicPlayer>()
                                              .addNew(
                                                song,
                                              );
                                        },
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            song.thumbnails.first.url,
                                            errorBuilder:
                                                ((context, error, stackTrace) {
                                              return Image.asset(
                                                  "assets/images/song.png");
                                            }),
                                          ),
                                        ),
                                        title: Text(
                                          song.title,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                        ),
                                        onLongPress: () {
                                          showOptions(song);
                                        },
                                        subtitle: Text(
                                          song.artists.first.name,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 93, 92, 92)),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              showOptions(song);
                                            },
                                            icon: const Icon(Icons.more_vert)),
                                      );
                                    }).toList()),
                                  if (!areSongs)
                                    SizedBox(
                                      height: 150,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: content.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 10);
                                        },
                                        itemBuilder: (context, index) {
                                          Map playlist = content[index] as Map;
                                          // print(song);

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
                                              child: Image.network(
                                                playlist['thumbnails']
                                                    .last['url'],
                                                errorBuilder: ((context, error,
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
