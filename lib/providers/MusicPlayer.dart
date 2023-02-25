import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:vibe_music/utils/file.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utils/connectivity.dart';

YoutubeExplode _youtubeExplode = YoutubeExplode();

class MusicPlayer extends ChangeNotifier {
  final AndroidLoudnessEnhancer _loudnessEnhancer = AndroidLoudnessEnhancer();
  AudioPlayer _player = AudioPlayer();
  bool _initialised = false;
  bool _isPlaying = false;
  bool _isOnline = false;
  Track? tempSong;
  final MiniplayerController _miniplayerController = MiniplayerController();
  StreamController<bool> _cancelController = StreamController<bool>();

  PaletteGenerator? _color;
  ConcatenatingAudioSource? playlist = ConcatenatingAudioSource(
    useLazyPreparation: false,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  MusicPlayer() {
    isConnectivity().then((value) {
      _isOnline = value;
    });

    Connectivity().onConnectivityChanged.listen((connectivity) {
      _isOnline = connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi;
    });
    _player = AudioPlayer(
      audioPipeline: AudioPipeline(androidAudioEffects: [_loudnessEnhancer]),
    );
    _player.setSkipSilenceEnabled(true);
    _loudnessEnhancer.setEnabled(true);
    _loudnessEnhancer.setTargetGain(0);
    _player.setVolume(1);
    _isPlaying = _player.playing;
    _player.setAudioSource(playlist!,
        initialIndex: 0, initialPosition: Duration.zero, preload: true);
    List recents = Hive.box('song_history').values.toList();
    if (recents.isNotEmpty) {
      recents.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));
      List songs = recents
          .getRange(0, recents.length > 10 ? 10 : recents.length)
          .toList();
      initializePlaylist(jsonDecode(jsonEncode(songs)));
    }
    _player.playerStateStream.listen((state) async {});
    _player.currentIndexStream.listen((event) {
      addSongHistory();
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

  addSongHistory() {
    if (_player.sequenceState?.currentSource != null) {
      String id = _player.sequenceState?.currentSource?.tag.id;
      Box box = Hive.box('song_history');
      Map? song = box.get(id);
      song ??= _player.sequenceState?.currentSource?.tag.extras;
      song?['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      song?['hits'] = song['hits'] != null ? (song['hits'] + 1) : 1;
      if (song != null) {
        box.put(id, song);
      }
    }
  }

  get player => _player;
  get isInitialized => _initialised;
  get isOnline => _isOnline;
  AndroidLoudnessEnhancer get loudnessEnhancer => _loudnessEnhancer;

  get miniplayerController => _miniplayerController;
  Track? get song => _player.sequenceState?.currentSource?.tag?.extras == null
      ? tempSong
      : Track.fromMap(_player.sequenceState?.currentSource?.tag?.extras);

  get songs =>
      _player.sequence?.map((e) => Track.fromMap(e.tag.extras)).toList() ?? [];

  get color => _color;
  get isPlaying => _isPlaying;

  addToQUeue(Track newSong) async {
    if (_player.sequence?.isEmpty ?? true) {
      addOneToQueue(newSong);
      return;
    }
    bool exists = _player.sequence
            ?.where((element) => element.tag.id == newSong.videoId)
            .isNotEmpty ??
        false;
    if (exists) {
      return;
    }
    PaletteGenerator? color =
        _isOnline ? await generateColor(newSong.thumbnails.last.url) : null;
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
          artist:
              newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
          extras: newSong.toMap(),
        ),
      ),
    )
        .then((value) {
      tempSong = null;
      notifyListeners();
    });
  }

  playNext(Track newSong) async {
    if (_player.sequence?.isEmpty ?? true) {
      addOneToQueue(newSong);
      return;
    }
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
    int ind = _player.currentIndex != null ? _player.currentIndex! + 1 : 0;
    playlist
        ?.insert(
      ind,
      AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: Uri.parse(newSong.thumbnails.last.url),
          artist:
              newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
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
    if (_player.playing) {
      await _player.stop();
    }
    playlist?.clear();
    playlist = null;
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: false,
      shuffleOrder: DefaultShuffleOrder(),
      children: [],
    );

    await _player.setAudioSource(playlist!,
        initialIndex: 0, initialPosition: Duration.zero, preload: true);
  }

  addNew(Track newSong) async {
    if (newSong.videoId == _player.sequenceState?.currentSource?.tag?.id) {
      _miniplayerController.animateToHeight(state: PanelState.MAX);
      return;
    }
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    try {
      PaletteGenerator? color = newSong.art != null
          ? await generateColor(newSong.art, local: true)
          : await generateColor(newSong.thumbnails.last.url);
      newSong.colorPalette = ColorPalette(
          darkMutedColor: color?.darkMutedColor?.color,
          lightMutedColor: color?.lightMutedColor?.color);
      tempSong = newSong;
      await setPlayer();

      _initialised = true;
      notifyListeners();

      _player.play().then((value) {
        notifyListeners();
        _miniplayerController.animateToHeight(state: PanelState.MAX);
      });

      await playlist
          ?.add(AudioSource.uri(
        await getAudioUri(newSong.videoId),
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: newSong.art != null
              ? File(newSong.art!).uri
              : Uri.parse(newSong.thumbnails.last.url),
          artist: newSong.artists.isNotEmpty
              ? newSong.artists.map((e) => e.name).join(', ')
              : null,
          album: newSong.albums?.name,
          extras: newSong.toMap(),
        ),
      ))
          .then((value) async {
        addSongHistory();
        tempSong = null;
        _miniplayerController.animateToHeight(state: PanelState.MAX);
        notifyListeners();
        await HomeApi.getWatchPlaylist(newSong.videoId, 10)
            .then((List value) async {
          List tracks = value;

          playlist?.sequence.first.tag.extras['artists'] = tracks[0]['artists'];
          tracks.removeAt(0);

          bool breakIt = false;
          _cancelController.stream.first.then((cancelled) async {
            if (cancelled) {
              breakIt = true;
            }
          });
          for (Map<String, dynamic> track in tracks) {
            if (breakIt) {
              break;
            }

            track['thumbnails'] = track['thumbnail'];
            Track tr = Track.fromMap(track);
            await addToQUeue(tr);
          }
        });
      });

      return true;
    } catch (e) {
      return true;
    }
  }

  playOne(a) async {
    File file = File(a['path']);
    if (!(await file.exists())) {
      await deleteFile(a['videoId']);
      return true;
    }
    Track newSong = Track.fromMap(a);

    if (newSong.videoId == _player.sequenceState?.currentSource?.tag?.id) {
      _miniplayerController.animateToHeight(state: PanelState.MAX);
      return;
    }
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    try {
      bool connectivity = await isConnectivity();
      PaletteGenerator? color = newSong.art != null
          ? await generateColor(newSong.art, local: true)
          : await generateColor(newSong.thumbnails.last.url);
      newSong.colorPalette = ColorPalette(
          darkMutedColor: color?.darkMutedColor?.color,
          lightMutedColor: color?.lightMutedColor?.color);
      tempSong = newSong;
      await setPlayer();

      _initialised = true;
      notifyListeners();

      _player.play().then((value) {
        notifyListeners();
        _miniplayerController.animateToHeight(state: PanelState.MAX);
      });
      log(connectivity.toString());
      await playlist
          ?.add(AudioSource.uri(
        file.uri,
        tag: MediaItem(
          id: newSong.videoId,
          title: newSong.title,
          artUri: newSong.art != null
              ? File(newSong.art!).uri
              : Uri.parse(newSong.thumbnails.last.url),
          artist:
              newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
          album: newSong.albums?.name,
          extras: newSong.toMap(),
        ),
      ))
          .then((value) async {
        addSongHistory();
        tempSong = null;
        _miniplayerController.animateToHeight(state: PanelState.MAX);
        notifyListeners();
      });

      return true;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  Future addPlayList(List newSongs) async {
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    tempSong = Track.fromMap(newSongs[0]);
    Track newSong = Track.fromMap(newSongs[0]);
    PaletteGenerator? color = newSong.art != null
        ? await generateColor(newSong.art, local: true)
        : await generateColor(newSong.thumbnails.last.url);
    newSong.colorPalette = ColorPalette(
        darkMutedColor: color?.darkMutedColor?.color,
        lightMutedColor: color?.lightMutedColor?.color);
    tempSong = newSong;
    await setPlayer();

    _initialised = true;
    _player.play().then((value) {
      notifyListeners();
      _miniplayerController.animateToHeight(state: PanelState.MAX);
    });
    notifyListeners();
    await playlist
        ?.add(AudioSource.uri(
      await getAudioUri(newSong.videoId),
      tag: MediaItem(
        id: newSong.videoId,
        title: newSong.title,
        artUri: newSong.art != null
            ? File(newSong.art!).uri
            : Uri.parse(newSong.thumbnails.last.url),
        artist: newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
        album: newSong.albums?.name,
        extras: newSong.toMap(),
      ),
    ))
        .then((value) async {
      addSongHistory();
      tempSong = null;
      _miniplayerController.animateToHeight(state: PanelState.MAX);
      notifyListeners();
      bool breakIt = false;
      _cancelController.stream.first.then((cancelled) async {
        if (cancelled) {
          breakIt = true;
        }
      });
      List nsongs = newSongs.sublist(1, newSongs.length);

      for (Map<String, dynamic> nSong in nsongs) {
        // If the loop has been cancelled, exit
        if (breakIt) {
          break;
        }

        Track ns = Track.fromMap(nSong);
        await addToQUeue(ns);
      }
    });
  }

  initializePlaylist(List newSongs) async {
    _cancelController.sink.add(true);
    _cancelController = StreamController<bool>();
    tempSong = Track.fromMap(newSongs[0]);
    Track newSong = Track.fromMap(newSongs[0]);

    bool connectivity = await isConnectivity();
    PaletteGenerator? color =
        connectivity ? await generateColor(newSong.thumbnails.last.url) : null;
    newSong.colorPalette = ColorPalette(
        darkMutedColor: color?.darkMutedColor?.color,
        lightMutedColor: color?.lightMutedColor?.color);
    tempSong = newSong;
    await setPlayer();

    _initialised = true;
    notifyListeners();

    await playlist
        ?.add(AudioSource.uri(
      await getAudioUri(newSong.videoId),
      tag: MediaItem(
        id: newSong.videoId,
        title: newSong.title,
        artUri: connectivity ? Uri.parse(newSong.thumbnails.last.url) : null,
        artist: newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
        album: newSong.albums?.name,
        extras: newSong.toMap(),
      ),
    ))
        .then((value) async {
      tempSong = null;
      notifyListeners();
      bool breakIt = false;
      _cancelController.stream.first.then((cancelled) async {
        if (cancelled) {
          breakIt = true;
        }
      });
      List nsongs = newSongs.sublist(1, newSongs.length);

      for (Map<String, dynamic> nSong in nsongs) {
        // If the loop has been cancelled, exit
        if (breakIt) {
          break;
        }

        // Add the item to the otherSongs list
        Track ns = Track.fromMap(nSong);
        await addToQUeue(ns);
      }
    });
  }

  Future addOneToQueue(Track newSong) async {
    PaletteGenerator? color = await generateColor(newSong.thumbnails.last.url);
    newSong.colorPalette = ColorPalette(
        darkMutedColor: color?.darkMutedColor?.color,
        lightMutedColor: color?.lightMutedColor?.color);
    tempSong = newSong;
    _initialised = true;

    notifyListeners();

    await playlist
        ?.add(AudioSource.uri(
      await getAudioUri(newSong.videoId),
      tag: MediaItem(
        id: newSong.videoId,
        title: newSong.title,
        artUri: Uri.parse(newSong.thumbnails.last.url),
        artist: newSong.artists.isNotEmpty ? newSong.artists.first.name : null,
        album: newSong.albums?.name,
        extras: newSong.toMap(),
      ),
    ))
        .then((value) {
      addSongHistory();
    });
  }

  /// Change the songe position in playlist from one index to another.

  Future moveTo(index, newIndex) async {
    // Track song = _songs.removeAt(index);
    // _songs.insertAll(newIndex, [song]);
    await playlist?.move(index, newIndex);
    notifyListeners();
    return true;
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
    Box box = Hive.box('settings');
    Map? download = Hive.box('downloads').get(videoId);
    if (download != null && download['path'] != null) {
      File file = File(download['path']);
      if (await file.exists()) {
        return file.uri;
      } else {
        Hive.box('downloads').delete(videoId);
      }
    }
    String audioQuality = box.get("audioQuality", defaultValue: 'medium');
    String audioUrl = '';
    try {
      final StreamManifest manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      List<AudioOnlyStreamInfo> audios = manifest.audioOnly.sortByBitrate();

      int audioNumber = audioQuality == 'low'
          ? 0
          : (audioQuality == 'high'
              ? audios.length - 1
              : (audios.length / 2).floor());

      audioUrl = audios[audioNumber].url.toString();

      return Uri.parse(audioUrl);
    } catch (e) {
      return Uri();
    }
  }
}
