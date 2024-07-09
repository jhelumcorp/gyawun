import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/services/bottom_message.dart';
import 'package:gyawun_beta/utils/enhanced_image.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

import '../../utils/extensions.dart';
import '../../services/media_player.dart';
import '../../utils/bottom_modals.dart';
import '../browse_screen/browse_screen.dart';

class SectionItem extends StatefulWidget {
  const SectionItem({required this.section, this.isMore = false, super.key});
  final Map section;
  final bool isMore;

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  final ScrollController horizontalScrollController = ScrollController();
  PageController horizontalPageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    horizontalPageController = PageController(
        viewportFraction: 350 / MediaQuery.of(context).size.width);
    return widget.section['contents'].isEmpty
        ? const SizedBox()
        : Column(
            children: [
              if (widget.section['title'] != null)
                AdaptiveListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: widget.section['strapline'] == null
                      ? Text(widget.section['title'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                      : Text(
                          widget.section['strapline'],
                          style: TextStyle(
                              color: Colors.grey.withAlpha(200), fontSize: 14),
                        ),
                  subtitle: widget.section['strapline'] != null
                      ? Text(widget.section['title'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.section['trailing'] != null)
                        AdaptiveOutlinedButton(
                          onPressed: () async {
                            if (widget.section['trailing']['playable'] ==
                                false) {
                              Navigator.push(
                                context,
                                AdaptivePageRoute.create(
                                  (context) => BrowseScreen(
                                    endpoint: widget.section['trailing']
                                        ['endpoint'],
                                    isMore: true,
                                  ),
                                ),
                              );
                            } else {
                              BottomMessage.showText(
                                  context, 'Songs will start playing soon.');
                              await GetIt.I<MediaPlayer>().startPlaylistSongs(
                                  widget.section['trailing']['endpoint']);
                            }
                          },
                          child: Text(widget.section['trailing']['text']),
                        ),
                      if (Platform.isWindows &&
                          widget.section['viewType'] != 'SINGLE_COLUMN')
                        AdaptiveIconButton(
                          icon: Icon(AdaptiveIcons.chevron_left),
                          onPressed: () {
                            if (widget.section['viewType'] == 'COLUMN' &&
                                !widget.isMore) {
                              horizontalPageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            } else {
                              horizontalScrollController.animateTo(
                                horizontalScrollController.offset -
                                    horizontalScrollController
                                        .position.extentInside,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                        ),
                      if (Platform.isWindows &&
                          widget.section['viewType'] != 'SINGLE_COLUMN')
                        AdaptiveIconButton(
                          icon: Icon(AdaptiveIcons.chevron_right),
                          onPressed: () {
                            if (widget.section['viewType'] == 'COLUMN' &&
                                !widget.isMore) {
                              horizontalPageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            } else {
                              horizontalScrollController.animateTo(
                                horizontalScrollController.offset +
                                    horizontalScrollController
                                        .position.extentInside,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                        )
                    ],
                  ),
                  leading: widget.section['thumbnails'] != null &&
                          widget.section['thumbnails']?.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            widget.section['thumbnails'].first['url'],
                          ),
                        )
                      : null,
                ),
              if (widget.section['viewType'] == 'COLUMN' && !widget.isMore)
                SongList(
                  songs: widget.section['contents'],
                  controller: horizontalPageController,
                )
              else if (widget.section['viewType'] == 'SINGLE_COLUMN' ||
                  widget.isMore)
                SingleColumnList(songs: widget.section['contents'])
              else
                ItemList(
                  items: widget.section['contents'],
                  controller: horizontalScrollController,
                ),
            ],
          );
  }
}

class SongList extends StatefulWidget {
  SongList({required this.songs, required this.controller, super.key});
  final List songs;
  PageController controller;

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  late int num;
  late int pages;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num = widget.songs.length <= 5 ? widget.songs.length : 4;
    pages = widget.songs.length ~/ num;
    pages = (pages * num) < widget.songs.length ? pages + 1 : pages;
    return ExpandablePageView.builder(
      controller: widget.controller,
      padEnds: false,
      itemCount: pages,
      itemBuilder: (context, index) {
        int start = index * num;
        int end = start + num;
        return Column(
          children: widget.songs
              .sublist(start, min(end, widget.songs.length))
              .map((pageSongs) {
            return SongTile(song: pageSongs);
          }).toList(),
        );
      },
    );
  }
}

class SingleColumnList extends StatelessWidget {
  const SingleColumnList({required this.songs, super.key});
  final List songs;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.map((song) {
        return SongTile(song: song);
      }).toList(),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({required this.song, this.playlistId, super.key});
  final String? playlistId;
  final Map song;
  @override
  Widget build(BuildContext context) {
    List thumbnails = song['thumbnails'];
    double height =
        (song['aspectRatio'] != null ? 50 / song['aspectRatio'] : 50)
            .toDouble();
    return Material(
      color: Colors.transparent,
      child: AdaptiveListTile(
          // borderRadius: BorderRadius.circular(5),
          // focusColor: greyColor,
          onTap: () async {
            if (song['endpoint'] != null && song['videoId'] == null) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        BrowseScreen(endpoint: song['endpoint']),
                  ));
            } else {
              await GetIt.I<MediaPlayer>().playSong(Map.from(song));
            }
          },
          onSecondaryTap: () {
            if (song['videoId'] != null) {
              Modals.showSongBottomModal(context, song);
            }
          },
          onLongPress: () {
            if (song['videoId'] != null) {
              Modals.showSongBottomModal(context, song);
            }
          },
          title: Text(song['title'] ?? "", maxLines: 1),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: CachedNetworkImage(
              imageUrl: thumbnails
                  .where((el) => el['width'] >= 50)
                  .toList()
                  .first['url'],
              height: height,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          subtitle: Text(
            _buildSubtitle(song),
            maxLines: 1,
            style: TextStyle(color: Colors.grey.withAlpha(250)),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: song['endpoint'] != null && song['videoId'] == null
              ? const Icon(CupertinoIcons.chevron_right)
              : null,
          description:
              (song['type'] == 'EPISODE' && song['description'] != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          ExpandableText(
                            song['description'].split('\n')?[0] ?? '',
                            expandText: 'Show More',
                            collapseText: 'Show Less',
                            maxLines: 3,
                            style: TextStyle(color: context.subtitleColor),
                          ),
                        ],
                      ),
                    )
                  : null),
    );
  }

  String _buildSubtitle(Map item) {
    List sub = [];
    if (sub.isEmpty && item['artists'] != null) {
      for (Map artist in item['artists']) {
        sub.add(artist['name']);
      }
    }
    if (sub.isEmpty && item['album'] != null) {
      sub.add(item['album']['name']);
    }
    String s = sub.join(' · ');
    return item['subtitle'] ?? s;
  }
}

class ItemList extends StatefulWidget {
  const ItemList({required this.items, this.controller, super.key});

  final List items;
  final ScrollController? controller;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late List items;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxWidth > 600 ? 200 : 150;

      return SizedBox(
        height: height + 72,
        child: ListView.separated(
          controller: widget.controller,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            double width = height * (items[index]?['aspectRatio'] ?? 1);
            String? subtitle = _buildSubtitle(items[index]);
            return AdaptiveInkWell(
              onTap: () async {
                if (items[index]['endpoint'] != null &&
                    items[index]['videoId'] == null) {
                  Navigator.push(
                      context,
                      AdaptivePageRoute.create(
                        (context) =>
                            BrowseScreen(endpoint: items[index]['endpoint']),
                      ));
                } else {
                  await GetIt.I<MediaPlayer>().playSong(Map.from(items[index]));
                }
              },
              onSecondaryTap: () {
                if (items[index]['videoId'] != null) {
                  Modals.showSongBottomModal(context, items[index]);
                } else if (items[index]['playlistId'] != null) {
                  Modals.showPlaylistBottomModal(context, items[index]);
                }
              },
              onLongPress: () {
                if (items[index]['videoId'] != null) {
                  Modals.showSongBottomModal(context, items[index]);
                } else if (items[index]['playlistId'] != null) {
                  Modals.showPlaylistBottomModal(context, items[index]);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  items[index]['type'] == 'ARTIST'
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            getEnhancedImage(
                                items[index]['thumbnails'].first['url'],
                                width: width.toInt()),
                          ),
                          radius: height / 2,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: getEnhancedImage(
                              items[index]['thumbnails'].first['url'],
                              width: width.toInt(),
                            ),
                            height: height,
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    width: width,
                    child: AdaptiveListTile(
                      title: Text(
                        items[index]['title'],
                        maxLines: 1,
                      ),
                      subtitle: subtitle != null
                          ? Text(subtitle,
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.grey.withAlpha(250)),
                              overflow: TextOverflow.ellipsis)
                          : null,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemCount: items.length,
        ),
      );
    });
  }

  String? _buildSubtitle(Map item) {
    List sub = [];
    if (item['subtitle'] != null) {
      sub.addAll(item['subtitle'].split('•'));
    } else if (item['description'] != null) {
      sub.addAll(item['description'].split(','));
    } else if (item['year'] != null) {
      sub.add(item['year']);
    }
    String s = sub.join(' • ').trim();
    return s.isEmpty ? null : s;
  }
}
