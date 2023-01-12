import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/widgets/TrackTile.dart';
import '../providers/MusicPlayer.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen(
      {required this.browseId,
      required this.imageUrl,
      required this.name,
      super.key});
  final String browseId;
  final String name;
  final String imageUrl;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  Map? artist;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    HomeApi.getArtist(widget.browseId).then((Map value) {
      setState(() {
        artist = value;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: artist == null || loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(widget.imageUrl),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.name,
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            ValueListenableBuilder(
                                valueListenable:
                                    Hive.box('settings').listenable(),
                                builder: (context, Box box, child) {
                                  bool isDarkTheme =
                                      box.get('theme', defaultValue: 'light') ==
                                          'dark';
                                  return MaterialButton(
                                    textColor: isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    onPressed: () async {
                                      await context
                                          .read<MusicPlayer>()
                                          .addPlayList(
                                            artist?['tracks'],
                                          );
                                    },
                                    child: Text(
                                      S.of(context).Play_All,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        S.of(context).Tracks,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium
                            ?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (artist != null)
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: artist?['tracks']?.length ?? 0,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> track =
                                artist?['tracks'][index];
                            if (track['videoId'] == null) {
                              artist?['tracks'].remove(track);
                              setState(() {});
                              return const SizedBox.shrink();
                            }

                            return TrackTile(
                              track: track,
                            );
                          }),
                  ],
                ),
              ),
      ),
    );
  }
}
