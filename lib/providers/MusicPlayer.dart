import 'dart:async';

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

  Track? tempSong;
  final MiniplayerController _miniplayerController = MiniplayerController();
  StreamController<bool> _cancelController = StreamController<bool>();

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

    _player.playerStateStream.listen((state) async {
      _index = _player.currentIndex ?? 0;
    });
    _player.currentIndexStream.listen((event) {
      _index = event ?? _index;
      notifyListeners();
    });
    _player.sequenceStream.listen((event) {
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
  Track? get song => _player.sequenceState?.currentSource?.tag.extras == null
      ? tempSong
      : Track.fromMap(_player.sequenceState?.currentSource?.tag.extras);

  get songs =>
      _player.sequence?.map((e) => Track.fromMap(e.tag.extras)).toList() ?? [];

  get color => _color;
  get isPlaying => _isPlaying;

  addToQUeue(Track newSong) async {
    bool exists = _player.sequence
            ?.where((element) => element.tag.id == newSong.videoId)
            .isNotEmpty ??
        false;
    if (exists) {
      return;
    }
    PaletteGenerator? color = await generateColor(newSong.thumbnails.last.url);
    newSong.colorPalette = ColorPalette(
        darkMutedColor: color?.darkMutedColor?.color,
        lightMutedColor: color?.lightMutedColor?.color);
    _initialised = true;
    notifyListeners();
    playlist
        ?.add(
      AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: Uri.parse(newSong.thumbnails.last.url),
          artist: newSong.artists.first.name,
          extras: newSong.toMap(),
        ),
      ),
    )
        .then((value) {
      tempSong = null;
      notifyListeners();
    });
  }

  Future setPlayer() async {
    await _player.stop();
    playlist!.clear();
    playlist = null;
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [],
    );
    // _songs.clear();

    await _player.setAudioSource(playlist!,
        initialIndex: 0, initialPosition: Duration.zero, preload: false);
  }

  addNew(Track newSong) async {
    if (newSong.videoId == _player.sequenceState?.currentSource?.tag.id) {
      _miniplayerController.animateToHeight(state: PanelState.MAX);
      return;
    }
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    try {
      PaletteGenerator? color =
          await generateColor(newSong.thumbnails.last.url);
      newSong.colorPalette = ColorPalette(
          darkMutedColor: color?.darkMutedColor?.color,
          lightMutedColor: color?.lightMutedColor?.color);
      tempSong = newSong;
      await setPlayer();

      _initialised = true;
      notifyListeners();

      _player.play();

      await playlist
          ?.add(AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: Uri.parse(newSong.thumbnails.last.url),
          artist: newSong.artists.first.name,
          album: newSong.albums?.name,
          extras: newSong.toMap(),
        ),
      ))
          .then((value) {
        tempSong = null;
        _miniplayerController.animateToHeight(state: PanelState.MAX);
        notifyListeners();
      });

      await HomeApi.getWatchPlaylist(newSong.videoId, 10)
          .then((List value) async {
        List tracks = value;
        // _songs[0].thumbnails.last.url = tracks[0]['thumbnail'].last['url'];
        tracks.removeAt(0);

        bool breakIt = false;
        _cancelController.stream.first.then((cancelled) async {
          if (cancelled) {
            breakIt = true;
          }
        });
        for (Map<String, dynamic> track in tracks) {
          // If the loop has been cancelled, exit

          if (breakIt) {
            break;
          }

          // Add the item to the otherSongs list

          track['thumbnails'] = track['thumbnail'];
          Track tr = Track.fromMap(track);
          await addToQUeue(tr);
        }
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  Future addPlayList(List newSongs) async {
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    tempSong = Track.fromMap(newSongs[0]);
    Track newSong = Track.fromMap(newSongs[0]);

    PaletteGenerator? color = await generateColor(newSong.thumbnails.last.url);
    newSong.colorPalette = ColorPalette(
        darkMutedColor: color?.darkMutedColor?.color,
        lightMutedColor: color?.lightMutedColor?.color);
    tempSong = newSong;
    await setPlayer();

    _initialised = true;
    notifyListeners();
    _miniplayerController.animateToHeight(state: PanelState.MAX);

    _player.play();

    bool breakIt = false;
    _cancelController.stream.first.then((cancelled) async {
      if (cancelled) {
        breakIt = true;
      }
    });

    for (Map<String, dynamic> nSong in newSongs) {
      // If the loop has been cancelled, exit
      if (breakIt) {
        break;
      }

      // Add the item to the otherSongs list
      Track newSong = Track.fromMap(nSong);
      await addToQUeue(newSong);
    }
  }

  /// Change the songe position in playlist from one index to another.

  moveTo(index, newIndex) async {
    // Track song = _songs.removeAt(index);
    // _songs.insertAll(newIndex, [song]);
    await playlist?.move(index, newIndex);
    notifyListeners();
  }

  removeAt(index) async {
    await playlist?.removeAt(index);
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

  /// Play the previous item, or does nothing if there is no previous item.
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

      return Uri.parse(audioUrl);
    } catch (e) {
      return Uri();
    }
  }
}
