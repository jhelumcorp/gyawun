import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/DownloadProvider.dart';
import 'package:vibe_music/providers/TD.dart';
import 'package:vibe_music/utils/file.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Downloads"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: pageIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      pageController.jumpToPage(0);
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    child: Text(
                      "Downloaded",
                      style: pageIndex == 0
                          ? Theme.of(context).primaryTextTheme.displaySmall
                          : TextStyle(
                              color: darkTheme ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: pageIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      pageController.jumpToPage(1);

                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    child: Text(
                      "Downloading",
                      style: pageIndex == 1
                          ? Theme.of(context).primaryTextTheme.displaySmall
                          : TextStyle(
                              color: darkTheme ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              children: [
                ValueListenableBuilder(
                    valueListenable: Hive.box('downloads').listenable(),
                    builder: (context, Box box, child) {
                      List favourites = box.values.toList();
                      favourites.sort((a, b) {
                        if (a['timestamp'] != null && b['timestamp'] != null) {
                          return a['timestamp']?.compareTo(b['timestamp']);
                        } else {
                          return a['title']?.compareTo(b['title']);
                        }
                      });
                      for (var element in favourites) {
                        File(element?['path'] ?? "").exists().then(
                          (value) {
                            if (!value && element['progress'] == 100) {
                              Hive.box('downloads').delete(element['videoId']);
                            }
                          },
                        );
                      }

                      if (favourites.isEmpty) {
                        return Center(
                          child: Text(
                            S.of(context).Nothing_Here,
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView(
                        primary: false,
                        children: favourites.map((track) {
                          Map<String, dynamic> newMap =
                              jsonDecode(jsonEncode(track));

                          return SwipeActionCell(
                            trailingActions: [
                              SwipeAction(
                                  icon: const Icon(Icons.delete_rounded),
                                  title: "DELETE",
                                  onTap: (CompletionHandler handler) async {
                                    await handler(true);
                                    await deleteFile(newMap['videoId']);
                                  },
                                  color: Colors.red),
                            ],
                            key: Key("$newMap['videoId']"),
                            child: DownloadTile(
                              tracks: favourites
                                  .map((e) => jsonDecode(jsonEncode(e)))
                                  .toList(),
                              index: favourites.indexOf(track),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...context.watch<DownloadManager>().getSongs.map((track) {
                        return SwipeActionCell(
                          trailingActions: [
                            SwipeAction(
                                icon: const Icon(Icons.delete_rounded),
                                title: "CANCEL",
                                onTap: (CompletionHandler handler) async {
                                  await handler(true);
                                  ChunkedDownloader? cd = context
                                      .read<DownloadManager>()
                                      .getManager(track['videoId']);
                                  cd?.stop();
                                },
                                color: Colors.red),
                          ],
                          key: Key("$track['videoId']"),
                          child: DownloadTile(
                            tracks: context
                                .watch<DownloadManager>()
                                .getSongs
                                .map((e) => jsonDecode(jsonEncode(e)))
                                .toList(),
                            index: context
                                .watch<DownloadManager>()
                                .getSongs
                                .indexOf(track),
                            downloading: true,
                          ),
                        );
                      }).toList()
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
