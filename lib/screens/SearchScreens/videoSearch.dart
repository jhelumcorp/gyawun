import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/providers/SearchProvider.dart';
import 'package:vibe_music/utils/showOptions.dart';

class VideoSearch extends StatefulWidget {
  const VideoSearch({this.query = "", super.key});
  final String query;

  @override
  State<VideoSearch> createState() => _VideoSearchState();
}

class _VideoSearchState extends State<VideoSearch> {
  @override
  Widget build(BuildContext context) {
    context.read<SearchProvider>().searchVideos(widget.query);
    return !context.watch<SearchProvider>().videosLoaded
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: context.watch<SearchProvider>().videos.map((track) {
                Track? song = Track.fromMap(track);
                return ListTile(
                  enableFeedback: false,
                  dense: true,
                  onTap: () async {
                    await context.read<MusicPlayer>().addNew(song);
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      // 'https://vibeapi-sheikh-haziq.vercel.app/thumb/sd?id=${song.videoId}',
                      song.thumbnails.first.url,
                      // width: 45,
                      height: 85,
                      fit: BoxFit.contain,
                      errorBuilder: ((context, error, stackTrace) {
                        return Image.asset("assets/images/song.png");
                      }),
                    ),
                  ),
                  title: Text(song.title,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(overflow: TextOverflow.ellipsis)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        song.artists.map((e) => e.name).toList().join(', '),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 92, 92),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (track['views'] != null)
                        Text(
                          track['views'],
                          style: const TextStyle(
                            color: Color.fromARGB(255, 93, 92, 92),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  onLongPress: () {
                    showOptions(song, context);
                  },
                );
              }).toList(),
            ),
          );
  }
}
