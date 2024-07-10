import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/services/media_player.dart';
import 'package:gyawun_beta/themes/text_styles.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:gyawun_beta/utils/bottom_modals.dart';
import 'package:gyawun_beta/ytmusic/ytmusic.dart';

class YoutubeHistory extends StatefulWidget {
  const YoutubeHistory({super.key});

  @override
  State<YoutubeHistory> createState() => _YoutubeHistoryState();
}

class _YoutubeHistoryState extends State<YoutubeHistory> {
  List sections = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  fetchHistory() async {
    setState(() {
      loading = true;
    });
    sections = await GetIt.I<YTMusic>().getHistory();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
        appBar: AdaptiveAppBar(
          title: const Text('Recently Played'),
          centerTitle: true,
          actions: [
            if (sections.isNotEmpty)
              AdaptiveIconButton(
                icon: Icon(AdaptiveIcons.delete),
                onPressed: () {
                  Modals.showConfirmBottomModal(context,
                          message:
                              'Are you sure you want to clear Recently Played history?',
                          isDanger: true)
                      .then((bool confirm) async {
                    if (confirm) {
                      Modals.showCenterLoadingModal(context);
                      List ids = [];
                      for (var section in sections) {
                        ids.addAll(section['contents']
                            .map((content) => content['feedbackToken'])
                            .toList());
                      }

                      bool deleted =
                          await GetIt.I<YTMusic>().removeHistoryItem(ids);
                      if (deleted) {
                        setState(() {
                          sections = [];
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                        fetchHistory();
                      }
                    }
                  });
                },
              )
          ],
        ),
        body: loading
            ? const Center(child: AdaptiveProgressRing())
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Column(
                        children: sections.indexed.map((section) {
                          int index = section.$1;
                          Map history = section.$2;
                          return Column(
                            children: [
                              if (history['title'] != null &&
                                  history['contents'].isNotEmpty)
                                AdaptiveListTile(
                                  title: Text(
                                    history['title']!,
                                    style: mediumTextStyle(context),
                                  ),
                                ),
                              ...history['contents'].map((item) {
                                return SwipeActionCell(
                                  key: Key(item['videoId']),
                                  backgroundColor: Colors.transparent,
                                  trailingActions: <SwipeAction>[
                                    SwipeAction(
                                        title: "Remove",
                                        onTap:
                                            (CompletionHandler handler) async {
                                          Modals.showConfirmBottomModal(context,
                                                  message:
                                                      'Are you sure you want to remove it from YTMusic?',
                                                  isDanger: true)
                                              .then((bool confirm) async {
                                            if (confirm) {
                                              Modals.showCenterLoadingModal(
                                                  context);
                                              bool deleted =
                                                  await GetIt.I<YTMusic>()
                                                      .removeHistoryItem(
                                                [item['feedbackToken']],
                                              );
                                              if (deleted) {
                                                setState(() {
                                                  sections[index]['contents']
                                                      .remove(item);
                                                });
                                              }
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            }
                                          });
                                        },
                                        color: Colors.red),
                                  ],
                                  child: AdaptiveListTile(
                                    title: Text(
                                      item['title'],
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(item['artists'] != null
                                        ? item['artists']
                                            .map((artist) => artist['name'])
                                            .join(',')
                                        : item['subtitle'] ??
                                            item['album']?['name'] ??
                                            ''),
                                    leading: CachedNetworkImage(
                                      imageUrl: item['thumbnails'].first['url'],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      GetIt.I<MediaPlayer>().playSong(item);
                                    },
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      )),
                ),
              ));
  }
}
