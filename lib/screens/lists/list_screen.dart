import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/api/api.dart';
import 'package:gyawun/api/extensions.dart';
import 'package:gyawun/api/ytmusic.dart';
import 'package:gyawun/components/playlist_album_header.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
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
  int num = 10;
  int page = 1;
  bool more = false;
  bool end = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > nextPageTrigger &&
          !end &&
          !more) {
        setState(() {
          more = true;
        });
        await fetchSongs(page: ++page, number: 50);
        setState(() {
          more = false;
        });
      }
    });
    // pprint(widget.list);
    loading = true;
    fetchSongs(number: 50, page: 1);
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
  void dispose() {
    super.dispose();

    _scrollController.dispose();
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
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaylistAlbumHeader(item: widget.list, songs: songs),
            const SizedBox(height: 8),
            Text(
              S.of(context).songs,
              style: textStyle(context, bold: true)
                  .copyWith(color: Theme.of(context).colorScheme.primary),
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
                    child: Text(S.of(context).title,
                        style: smallTextStyle(context)),
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
                    child: Text(S.of(context).date,
                        style: smallTextStyle(context)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      ...songs.map((song) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onTap: () {
                            int index = songs.indexOf(song);
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
                                    width: song['type'] == 'video' ? 80 : 50,
                                    height: 50,
                                    fit: BoxFit.contain),
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
                      if (more) const Center(child: CircularProgressIndicator())
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future fetchSongs({int page = 1, int number = 500}) async {
    List list = [];
    if (widget.list['type'] == 'playlist' || widget.list['type'] == 'chart') {
      if (widget.list['provider'] == 'youtube') {
        Map songMap = await YtMusicService().getPlaylistDetails(
            widget.list['id'].toString().replaceAll('youtube', ''));
        list = songMap['songs'];
      } else {
        Map songMap = await SaavnAPI().fetchPlaylistSongs(widget.list['id']);
        list = songMap['songs'];
      }
    } else if (widget.list['type'] == 'album') {
      if (widget.list['provider'] == 'youtube') {
        Map<dynamic, dynamic> songMap = await YtMusicService().getAlbumDetails(
            widget.list['id'].toString().replaceAll('youtube', ''));

        list = songMap['songs'];
      } else {
        Map songMap = await SaavnAPI().fetchAlbumSongs(widget.list['id']);
        list = songMap['songs'];
      }
    } else if (widget.list['type'] == 'mix') {
      Map songMap = await SaavnAPI().getSongFromToken(
          widget.list['perma_url'].toString().split('/').last, 'mix',
          n: number * page, p: 1);
      list = songMap['songs'];
    } else if (widget.list['type'] == 'show') {
      Map songMap = await SaavnAPI().getSongFromToken(
          widget.list['perma_url'].toString().split('/').last, 'show',
          n: number * page, p: 1);
      list = songMap['songs'].map((e) {
        e['url'] = e['url']
            .toString()
            .substring(0, e['url'].toString().lastIndexOf('.') + 4);

        return e;
      }).toList();
    } else if (widget.list['type'] == 'single') {
      Map<dynamic, dynamic> songMap = await YtMusicService().getAlbumDetails(
          widget.list['id'].toString().replaceAll('youtube', ''));
      // pprint(songMap);
      list = songMap['songs'];
    }
    if (mounted) {
      songs = list;
      copySongs = List.from(list);
      loading = false;
      setState(() {
        if (list.length < number * page) end = true;
      });
    }
  }
}
