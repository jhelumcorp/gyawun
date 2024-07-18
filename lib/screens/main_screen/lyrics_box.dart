import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../services/lyrics.dart';
import '../../services/media_player.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';

class LyricsBox extends StatefulWidget {
  const LyricsBox({required this.currentSong, required this.size, super.key});
  final MediaItem currentSong;
  final Size size;

  @override
  State<LyricsBox> createState() => _LyricsBoxState();
}

class _LyricsBoxState extends State<LyricsBox> {
  Future<Map>? _fetchLyricsFuture;

  @override
  void initState() {
    super.initState();
    _initFetchLyrics();
  }

  void _initFetchLyrics() {
    GetIt.I<MediaPlayer>().progressBarState.addListener(_progressListener);

    if (GetIt.I<MediaPlayer>().progressBarState.value.total.inSeconds > 0) {
      _fetchLyrics();
    }
  }

  void _progressListener() {
    if (GetIt.I<MediaPlayer>().progressBarState.value.total.inSeconds > 0) {
      _fetchLyrics();
      GetIt.I<MediaPlayer>().progressBarState.removeListener(_progressListener);
    }
  }

  @override
  void didUpdateWidget(covariant LyricsBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentSong != oldWidget.currentSong) {
      _initFetchLyrics();
    }
  }

  void _fetchLyrics() {
    if (context.mounted) {
      setState(() {
        _fetchLyricsFuture = GetIt.I<Lyrics>().getLyrics(
          videoId: widget.currentSong.id,
          title: widget.currentSong.title,
          artist: widget.currentSong.artist,
          album: widget.currentSong.album,
          durationInSeconds:
              GetIt.I<MediaPlayer>().progressBarState.value.total.inSeconds,
        );
      });
    }
  }

  @override
  void dispose() {
    GetIt.I<MediaPlayer>().progressBarState.removeListener(_progressListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ValueListenableBuilder(
            valueListenable: GetIt.I<MediaPlayer>().progressBarState,
            builder: (context, progress, child) {
              return progress.total.inSeconds > 0 && _fetchLyricsFuture != null
                  ? FutureBuilder(
                      future: _fetchLyricsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == null) {
                            return const Text('No Lyrics');
                          }
                          if (snapshot.data!['success'] == false) {
                            return const Text('No Lyrics');
                          }
                          Map lyrics = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable:
                                  GetIt.I<MediaPlayer>().progressBarState,
                              builder: (context, progress, child) {
                                return LyricsReader(
                                  padding: EdgeInsets.zero,
                                  position: progress.current.inMilliseconds,
                                  playing: context
                                      .watch<MediaPlayer>()
                                      .player
                                      .playing,
                                  lyricUi: UINetease(
                                    highlight: false,
                                    defaultSize: 19,
                                  ),
                                  model: LyricsModelBuilder.create()
                                      .bindLyricToMain(
                                        (lyrics['syncedLyrics']).toString(),
                                      )
                                      .getModel(),
                                  emptyBuilder: () => SingleChildScrollView(
                                    child: Center(
                                      child: Text(
                                        lyrics['plainLyrics'] ?? "No lyrics",
                                        style: UINetease(
                                                highlight: false,
                                                defaultSize: 19)
                                            .getOtherMainTextStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  size: widget.size,
                                );
                              });
                        }
                        if (snapshot.hasError) {
                          return const Text('No Lyrics');
                        }
                        return const AdaptiveProgressRing();
                      },
                    )
                  : const AdaptiveProgressRing();
            }),
      ),
    );
  }
}
