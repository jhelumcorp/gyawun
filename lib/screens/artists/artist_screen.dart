import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/api/api.dart';
import 'package:gyawun/api/image_resolution_modifier.dart';
import 'package:gyawun/api/ytmusic.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/screens/lists/list_screen.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatefulWidget {
  final Map<String, dynamic> artist;
  const ArtistScreen({required this.artist, super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool loading = false;
  List<Map<String, dynamic>> results = [];
  late Map artist;
  @override
  void initState() {
    super.initState();
    artist = widget.artist;
    fetchArtist();
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            padding: const EdgeInsets.all(4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            color: Theme.of(context).colorScheme.surfaceTint.withAlpha(100),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: getImageUrl(artist['image']),
                        height: imageWidth,
                        width: imageWidth,
                      ),
                      Container(
                        height: imageWidth,
                        width: imageWidth,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).scaffoldBackgroundColor
                            ],
                          ),
                        ),
                        child: Text(artist['title'], style: textStyle(context)),
                      ),
                    ],
                  ),
                  ...results.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item['title'],
                            style: textStyle(context).copyWith(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 210,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: item['items'].length,
                            itemBuilder: (context, index) {
                              Map song = item['items'][index];

                              return GestureDetector(
                                onTap: () {
                                  if (song['type'] == 'song') {
                                    context.read<MediaManager>().addAndPlay(
                                        item['items'],
                                        initialIndex:
                                            item['items'].indexOf(song));
                                  } else if (song['type'] == 'artist') {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => ArtistScreen(
                                          artist: Map.from(song),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => ListScreen(
                                          list: Map.from(song),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                onLongPress: () {
                                  if (song['type'] == 'song') {
                                    showSongOptions(context, Map.from(song));
                                  }
                                },
                                child: SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            song['type'] == 'artist' ? 75 : 10),
                                        child: CachedNetworkImage(
                                          imageUrl: getImageUrl(song['image']),
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                            song['title'],
                                            style: smallTextStyle(context,
                                                bold: true),
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                          ),
                        ),
                      ],
                    );
                  }).toList()
                ],
              ),
            ),
    );
  }

  fetchArtist() async {
    setState(() {
      loading = true;
    });
    if (widget.artist['provider'] == 'youtube') {
      Map<String, dynamic> artist = await YtMusicService().getArtistDetails(
          widget.artist['id'].toString().replaceAll('youtube', ''));

      results.add({
        'title': 'Songs',
        'items': artist['songs'],
      });
    } else {
      Map<String, List<dynamic>> value = await SaavnAPI()
          .fetchArtistSongs(artistToken: widget.artist['artistToken']);

      value.forEach((key, value) {
        results.add({
          'title': key,
          'items': value,
        });
      });
    }
    loading = false;
    setState(() {});
  }
}
