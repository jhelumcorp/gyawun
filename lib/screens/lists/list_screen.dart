import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gyavun/api/api.dart';
import 'package:gyavun/api/extensions.dart';
import 'package:gyavun/components/playlist_album_header.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/option_menu.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  final Map list;

  const ListScreen({required this.list, super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool loading = false;
  List songs = [];
  List copySongs = [];
  bool ascending = true;
  String param = '';

  @override
  void initState() {
    super.initState();
    loading = true;
    fetchSongs();
  }

  sort({String param = 'title'}) {
    if (songs[0][param] == null) return;
    if (ascending) {
      songs.sort((a, b) => b[param].toString().compareTo(a[param].toString()));
    } else {
      songs.sort((a, b) => a[param].toString().compareTo(b[param].toString()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaManager mediaManager = context.read<MediaManager>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list['type'].toString().capitalize(),
            style: textStyle(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaylistAlbumHeader(item: widget.list, songs: songs),
            const SizedBox(height: 8),
            Text(
              'Songs',
              style: textStyle(context, bold: true)
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  IconButton(
                    color: Theme.of(context).primaryColor.withAlpha(170),
                    onPressed: () {
                      setState(() {
                        ascending = !(ascending);
                      });
                      sort(param: param);
                    },
                    icon: Icon(ascending
                        ? EvaIcons.arrowDownOutline
                        : EvaIcons.arrowUp),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    color: param == 'title'
                        ? Theme.of(context).primaryColor.withAlpha(170)
                        : darkGreyColor.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      if (param == 'title') {
                        songs = List.from(copySongs);
                        param = '';
                        setState(() {});
                      } else {
                        param = 'title';
                        sort(param: param);
                      }
                    },
                    child: Text('Title', style: smallTextStyle(context)),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    color: param == 'release_date'
                        ? Theme.of(context).primaryColor.withAlpha(170)
                        : darkGreyColor.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      if (param == 'release_date') {
                        songs = List.from(copySongs);
                        param = '';
                        setState(() {});
                      } else {
                        param = 'release_date';
                        sort(param: param);
                      }
                    },
                    child: Text('Date', style: smallTextStyle(context)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: songs.map((song) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onTap: () {
                          int index = songs.indexOf(song);
                          log(index.toString());
                          mediaManager.addAndPlay(songs, initialIndex: index);
                        },
                        onLongPress: () =>
                            showSongOptions(context, Map.from(song)),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                  imageUrl: song['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill),
                            ],
                          ),
                        ),
                        title: Text(song['title'],
                            style: smallTextStyle(context, bold: true),
                            maxLines: 1),
                        subtitle: Text(song['subtitle'],
                            style: smallTextStyle(context), maxLines: 1),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  fetchSongs() async {
    List list = [];
    if (widget.list['type'] == 'playlist') {
      Map songMap = await SaavnAPI().fetchPlaylistSongs(widget.list['id']);
      list = songMap['songs'];
    } else if (widget.list['type'] == 'album') {
      Map songMap = await SaavnAPI().fetchAlbumSongs(widget.list['id']);
      list = songMap['songs'];
    } else if (widget.list['type'] == 'mix') {
      Map songMap = await SaavnAPI().getSongFromToken(
          widget.list['perma_url'].toString().split('/').last, 'mix',
          n: 100);
      list = songMap['songs'];
    } else if (widget.list['type'] == 'show') {
      Map songMap = await SaavnAPI().getSongFromToken(
          widget.list['perma_url'].toString().split('/').last, 'show',
          n: 500, p: 1);
      list = songMap['songs'].map((e) {
        e['url'] = e['url']
            .toString()
            .substring(0, e['url'].toString().lastIndexOf('.') + 4);
        return e;
      }).toList();
    }
    songs = list;
    copySongs = List.from(list);
    loading = false;
    setState(() {});
  }
}
