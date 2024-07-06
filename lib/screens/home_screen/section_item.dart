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

import '../../utils/extensions.dart';
import '../../services/media_player.dart';
import '../../themes/colors.dart';
import '../../utils/bottom_modals.dart';
import '../browse_screen/browse_screen.dart';

class SectionItem extends StatelessWidget {
  const SectionItem({required this.section, this.isMore = false, super.key});
  final Map section;
  final bool isMore;
  @override
  Widget build(BuildContext context) {
    return section['contents'].isEmpty
        ? const SizedBox()
        : Column(
            children: [
              if (section['title'] != null)
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  title: section['strapline'] == null
                      ? Text(section['title'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                      : Text(
                          section['strapline'],
                          style: TextStyle(
                              color: Colors.grey.withAlpha(200), fontSize: 14),
                        ),
                  subtitle: section['strapline'] != null
                      ? Text(section['title'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                      : null,
                  trailing: section['trailing'] != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                if (section['trailing']['playable'] == false) {
                                  Navigator.push(
                                    context,
                                    Platform.isWindows
                                        ? MaterialPageRoute(
                                            builder: (context) => BrowseScreen(
                                              endpoint: section['trailing']
                                                  ['endpoint'],
                                              isMore: true,
                                            ),
                                          )
                                        : CupertinoPageRoute(
                                            builder: (context) => BrowseScreen(
                                              endpoint: section['trailing']
                                                  ['endpoint'],
                                              isMore: true,
                                            ),
                                          ),
                                  );
                                } else {
                                  BottomMessage.showText(context,
                                      'Songs will start playing soon.');
                                  await GetIt.I<MediaPlayer>()
                                      .startPlaylistSongs(
                                          section['trailing']['endpoint']);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: context.subtitleColor,
                                  ),
                                ),
                                child: Text(section['trailing']['text']),
                              ),
                            ),
                          ],
                        )
                      : null,
                  leading: section['thumbnails'] != null &&
                          section['thumbnails']?.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            section['thumbnails'].first['url'],
                          ),
                        )
                      : null,
                ),
              if (section['viewType'] == 'COLUMN' && !isMore)
                SongList(songs: section['contents'])
              else if (section['viewType'] == 'SINGLE_COLUMN' || isMore)
                SingleColumnList(songs: section['contents'])
              else
                ItemList(items: section['contents']),
            ],
          );
  }
}

class SongList extends StatefulWidget {
  const SongList({required this.songs, super.key});
  final List songs;

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int num = widget.songs.length <= 5 ? widget.songs.length : 4;
    int pages = widget.songs.length ~/ num;
    pages = (pages * num) < widget.songs.length ? pages + 1 : pages;
    _pageController = PageController(
        viewportFraction:
            max(pages, 1) == 1 ? 1 : 350 / MediaQuery.of(context).size.width);
    return ExpandablePageView.builder(
      controller: _pageController,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        focusColor: greyColor,
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
        child: Column(
          children: [
            ListTile(
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
            ),
            if (song['type'] == 'EPISODE' && song['description'] != null)
              Padding(
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
                    const Divider(),
                  ],
                ),
              )
          ],
        ),
      ),
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
  const ItemList({required this.items, super.key});

  final List items;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            double width = height * (items[index]?['aspectRatio'] ?? 1);
            String? subtitle = _buildSubtitle(items[index]);
            return InkWell(
              onTap: () async {
                if (items[index]['endpoint'] != null &&
                    items[index]['videoId'] == null) {
                  Navigator.push(
                      context,
                      Platform.isWindows
                          ? MaterialPageRoute(
                              builder: (context) => BrowseScreen(
                                  endpoint: items[index]['endpoint']),
                            )
                          : CupertinoPageRoute(
                              builder: (context) => BrowseScreen(
                                  endpoint: items[index]['endpoint']),
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
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                    child: ListTile(
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
