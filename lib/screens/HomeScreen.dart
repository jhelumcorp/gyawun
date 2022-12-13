import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/providers/HomeScreenProvider.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:we_slide/we_slide.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.weSlideController,
    super.key,
  });
  final WeSlideController? weSlideController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
                  title: const Text("Add to Queue"),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Track? song = context.watch<MusicPlayer>().song;
    return Scaffold(
      body: context.watch<HomeScreenProvider>().isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ...context
                            .watch<HomeScreenProvider>()
                            .getData
                            .map((item) {
                          String title = item['title'];
                          List content = item['contents'] as List;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (title == "Quick picks")
                                  Column(
                                      children: content.map((s) {
                                    Track song = Track.fromJson(jsonEncode(s));
                                    return ListTile(
                                      onTap: () async {
                                        await context
                                            .read<MusicPlayer>()
                                            .addNew(
                                                song, widget.weSlideController);
                                      },
                                      leading: Image.network(
                                          song.thumbnails.first.url),
                                      title: Text(
                                        song.title,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      onLongPress: () {
                                        showOptions(song);
                                      },
                                      subtitle: Text(song.artists.first.name),
                                      trailing: IconButton(
                                          onPressed: () {
                                            showOptions(song);
                                          },
                                          icon: const Icon(Icons.more_vert)),
                                    );
                                  }).toList()),
                                if (title != "Quick picks")
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
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        backgroundColor:
            song?.colorPalette?.lightVibrantColor?.color ?? primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.search),
      ),
    );
  }
}
