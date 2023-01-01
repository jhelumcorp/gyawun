import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

YoutubeExplode _youtubeExplode = YoutubeExplode();

class MusicPlayer extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  int _index = 0;
  bool _initialised = false;
  bool _isPlaying = false;
  List<Track> _songs = [];
  MiniplayerController _miniplayerController = MiniplayerController();

  PaletteGenerator? _color;
  ConcatenatingAudioSource? playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  MusicPlayer() {
    _isPlaying = _player.playing;
    _player.setAudioSource(playlist!,
        initialIndex: 0, initialPosition: Duration.zero, preload: false);
    init();
    _player.playerStateStream.listen((state) async {
      _index = _player.currentIndex ?? 0;
    });
    _player.currentIndexStream.listen((event) {
      _index = event ?? _index;
      notifyListeners();
    });
    _player.loopModeStream.listen((event) {
      notifyListeners();
    });
    _player.shuffleModeEnabledStream.listen((event) {
      notifyListeners();
    });
  }

  init() async {}

  get player => _player;
  get isInitialized => _initialised;
  get miniplayerController => _miniplayerController;
  get song {
    if (_songs.isEmpty) {
      return null;
    } else if (_player.currentIndex == null) {
      return _songs[0];
    } else if (_player.currentIndex! >= _songs.length) {
      return _songs[0];
    } else {
      return _songs[_player.currentIndex!];
    }
  }

  get songs => _songs;
  get color => _color;
  get isPlaying => _isPlaying;

  addToQUeue(Track newSong) async {
    PaletteGenerator? color = await generateColor(newSong.thumbnails.last.url);
    newSong.colorPalette = color;
    _songs.add(newSong);
    _initialised = true;
    notifyListeners();
    playlist?.add(
      AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: Uri.parse(newSong.thumbnails.last.url),
          artist: newSong.artists.first.name,
        ),
      ),
    );
  }

  setPlayer() async {
    await _player.stop();
    playlist!.clear();
    _songs.clear();

    _player.setAudioSource(playlist!,
        initialIndex: 0, initialPosition: Duration.zero, preload: false);
  }

  addNew(Track newSong) async {
    try {
      PaletteGenerator? color =
          await generateColor(newSong.thumbnails.last.url);
      newSong.colorPalette = color;

      await setPlayer();

      _songs = [newSong];

      _initialised = true;

      notifyListeners();
      _miniplayerController.animateToHeight(state: PanelState.MAX);

      await playlist?.add(AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: Uri.parse(newSong.thumbnails.last.url),
          artist: newSong.artists.first.name,
          album: newSong.albums?.name,
        ),
      ));

      _player.play();
      await HomeApi.getWatchPlaylist(newSong.videoId, 10)
          .then((List value) async {
        List tracks = value;
        _songs[0].thumbnails.last.url = tracks[0]['thumbnail'].last['url'];
        tracks.removeAt(0);
        for (var track in tracks) {
          if (playlist == null || playlist!.length >= 10) {
            break;
          }
          try {
            track['thumbnails'] = track['thumbnail'];
            Track tr = Track.fromMap(track);
            await addToQUeue(tr);
          } catch (e) {
            log(e.toString());
          }
        }
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  Future addPlayList(List newSongs) async {
    _initialised = true;
    setPlayer();
    int i = 0;
    for (Map<String, dynamic> nSong in newSongs) {
      if (playlist != null) {
        Track newSong = Track.fromMap(nSong);
        await addToQUeue(newSong);
        if (i == 0) {
          _player.play();
          _miniplayerController.animateToHeight(state: PanelState.MAX);
        }

        i += 1;
      } else {
        break;
      }
    }
  }

  /// Change the songe position in playlist from one index to another.

  moveTo(index, newIndex) {
    Track song = _songs.removeAt(index);
    _songs.insertAll(newIndex, [song]);
    playlist?.move(index, newIndex);
    notifyListeners();
  }

  /// Toggle Audio Play and pause
  togglePlay() {
    _player.playing ? _player.pause() : _player.play();
  }

  toggleLoop() {
    _player.setLoopMode(
        _player.loopMode == LoopMode.one ? LoopMode.off : LoopMode.one);
    notifyListeners();
  }

  toggleShuffle() {
    _player.setShuffleModeEnabled(!_player.shuffleModeEnabled);
    notifyListeners();
  }

  /// Play the next song in the playlist. If the current song is last one, nothing will happen.
  next() {
    _player.seekToNext();
    if (!_player.playing) _player.play();
  }

  /// Play the previous song in the playlist. If the current song is first one, nothing will happen.
  previous() {
    _player.seekToPrevious();
    if (!_player.playing) _player.play();
  }

  static Future<Uri> getAudioUri(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String audioQuality = prefs.getString("audioQuality") ?? "medium";
    String audioUrl = '';
    try {
      final StreamManifest manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      List<AudioOnlyStreamInfo> audios = manifest.audioOnly.sortByBitrate();

      int audioNumber = audioQuality == 'high'
          ? 0
          : (audioQuality == 'low'
              ? audios.length - 1
              : (audios.length / 2).floor());

      audioUrl = audios[audioNumber].url.toString();
      // log(audios[audioNumber].size.totalMegaBytes.toString());
      // log(audioQuality);
      return Uri.parse(audioUrl);
    } catch (e) {
      return Uri();
    }
  }
}
