import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/pprint.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../utils/add_history.dart';
import '../ytmusic/ytmusic.dart';
import 'settings_manager.dart';

class MediaPlayer extends ChangeNotifier {
  late AudioPlayer _player;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);

  final _loudnessEnhancer = AndroidLoudnessEnhancer();
  final _equalizer = AndroidEqualizer();
  AndroidEqualizerParameters? _equalizerParams;

  List<IndexedAudioSource>? _songList = [];
  MediaItem? _currentSong;
  int? _currentIndex;
  ButtonState _buttonState = ButtonState.loading;
  Timer? _timer;
  final ValueNotifier<Duration?> _timerDuration = ValueNotifier(null);

  final ValueNotifier<LoopMode> _loopMode = ValueNotifier(LoopMode.off);

  final ValueNotifier<ProgressBarState> _progressBarState =
      ValueNotifier(ProgressBarState());

  bool _shuffleModeEnabled = false;
  String serverAddress;
  MediaPlayer(this.serverAddress) {
    final AudioPipeline pipeline = AudioPipeline(
      androidAudioEffects: [
        _equalizer,
        _loudnessEnhancer,
      ],
    );
    _player = AudioPlayer(audioPipeline: pipeline);
    GetIt.I.registerSingleton<AndroidLoudnessEnhancer>(_loudnessEnhancer);
    GetIt.I.registerSingleton<AndroidEqualizer>(_equalizer);
    _init();
  }
  AudioPlayer get player => _player;
  ConcatenatingAudioSource get playlist => _playlist;
  List<IndexedAudioSource>? get songList => _songList;
  MediaItem? get currentSong => _currentSong;
  int? get currentIndex => _currentIndex;
  ButtonState get buttonState => _buttonState;

  ValueNotifier<ProgressBarState> get progressBarState => _progressBarState;
  bool get shuffleModeEnabled => _shuffleModeEnabled;
  ValueNotifier<LoopMode> get loopMode => _loopMode;
  ValueNotifier<Duration?> get timerDuration => _timerDuration;
  _init() async {
    await _loadLoudnessEnhancer();
    await _loadEqualizer();
    await _player.setAudioSource(_playlist);
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    _listenToShuffle();
  }

  _loadLoudnessEnhancer() async {
    await _loudnessEnhancer
        .setEnabled(GetIt.I<SettingsManager>().loudnessEnabled);

    await _loudnessEnhancer
        .setTargetGain(GetIt.I<SettingsManager>().loudnessTargetGain);
  }

  _loadEqualizer() async {
    await _equalizer.setEnabled(GetIt.I<SettingsManager>().equalizerEnabled);
    _equalizer.parameters.then((value) async {
      _equalizerParams ??= value;
      final List<AndroidEqualizerBand> bands = _equalizerParams!.bands;
      if (GetIt.I<SettingsManager>().equalizerBandsGain.isEmpty) {
        GetIt.I<SettingsManager>().equalizerBandsGain =
            List.generate(bands.length, (index) => 0.0);
      }

      List<double> equalizerBandsGain =
          GetIt.I<SettingsManager>().equalizerBandsGain;
      for (var e in bands) {
        final gain =
            equalizerBandsGain.isNotEmpty ? equalizerBandsGain[e.index] : 0.0;
        _equalizerParams!.bands[e.index].setGain(gain);
      }
    });
  }

  Future<void> setLoudnessEnabled(bool value) async {
    await _loudnessEnhancer.setEnabled(value);
    GetIt.I<SettingsManager>().loudnessEnabled = value;
  }

  Future<void> setEqualizerEnabled(bool value) async {
    await _equalizer.setEnabled(value);
    GetIt.I<SettingsManager>().equalizerEnabled = value;
  }

  Future<void> setLoudnessTargetGain(double value) async {
    await _loudnessEnhancer.setTargetGain(value);
    GetIt.I<SettingsManager>().loudnessTargetGain = value;
  }

  void _listenToChangesInPlaylist() async {
    _player.sequenceStream.listen((playlist) {
      if (playlist == _songList) return;
      bool shouldAdd = false;
      if ((_songList == null || _songList!.isEmpty) &&
          playlist != null &&
          playlist.isNotEmpty) {
        shouldAdd = true;
      }
      if (playlist == null || playlist.isEmpty) {
        _currentSong = null;
        _currentIndex == null;
        _songList = [];
      } else {
        _currentIndex ??= 0;
        _songList = playlist;

        _currentSong ??= (_songList!.length > _currentIndex!)
            ? _songList![_currentIndex!].tag
            : null;
      }
      if (shouldAdd == true && _currentSong != null) {
        addHistory(_currentSong!.extras!);
      }
      notifyListeners();
    });
  }

  void _listenToPlaybackState() {
    _player.playerStateStream.listen((event) {
      final isPlaying = event.playing;
      final processingState = event.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        _buttonState = ButtonState.loading;
        notifyListeners();
      } else if (!isPlaying || processingState == ProcessingState.idle) {
        _buttonState = ButtonState.paused;
        notifyListeners();
      } else if (processingState != ProcessingState.completed) {
        _buttonState = ButtonState.playing;
        notifyListeners();
      } else {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    _player.positionStream.listen((position) {
      final oldState = _progressBarState.value;
      if (oldState.current != position) {
        _progressBarState.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      }
    });
  }

  void _listenToBufferedPosition() async {
    _player.bufferedPositionStream.listen((position) {
      final oldState = _progressBarState.value;
      if (oldState.buffered != position) {
        _progressBarState.value = ProgressBarState(
          current: oldState.current,
          buffered: position,
          total: oldState.total,
        );
      }
    });
  }

  void _listenToTotalDuration() async {
    _player.durationStream.listen((position) {
      final oldState = _progressBarState.value;
      if (oldState.total != position) {
        _progressBarState.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: position ?? Duration.zero,
        );
      }
    });
  }

  void _listenToShuffle() {
    _player.shuffleModeEnabledStream.listen((data) {
      _shuffleModeEnabled = data;
      notifyListeners();
    });
  }

  void _listenToChangesInSong() async {
    _player.currentIndexStream.listen((index) {
      if (_songList != null && _currentIndex != index) {
        _currentIndex = index;
        _currentSong = index != null &&
                songList!.isNotEmpty &&
                _songList?.elementAt(index) != null
            ? _songList![index].tag
            : null;

        notifyListeners();
        if (_songList!.isNotEmpty && _currentIndex != null) {
          MediaItem item = _songList![_currentIndex!].tag;
          addHistory(item.extras!);
        }
      }
    });
  }

  changeLoopMode() {
    switch (_loopMode.value) {
      case LoopMode.off:
        _loopMode.value = LoopMode.all;

        break;
      case LoopMode.all:
        _loopMode.value = LoopMode.one;
        break;
      default:
        _loopMode.value = LoopMode.off;
        break;
    }
    _player.setLoopMode(_loopMode.value);
  }

  Future<void> skipSilence(bool value) async {
    await _player.setSkipSilenceEnabled(value);
    GetIt.I<SettingsManager>().skipSilence = value;
  }

  Future<void> playSong(Map<String, dynamic> song,
      {bool autoFetch = true}) async {
    // await YTMusic.getData();
    // return;
    if (song['videoId'] != null) {
      await _player.pause();
      await _playlist.clear();
      Uri uri = Uri.parse(song['status'] == 'DOWNLOADED' &&
              song['path'] != null &&
              (await File(song['path']).exists())
          ? song['path']
          : 'http://$serverAddress?id=${song['videoId']}&quality=${GetIt.I<SettingsManager>().audioQuality.name.toLowerCase()}');
      pprint(GetIt.I<SettingsManager>().audioQuality.name.toLowerCase());
      await _playlist.add(
        AudioSource.uri(
          uri,
          tag: MediaItem(
            id: song['videoId'],
            title: song['title'] ?? 'Title',
            album: song['album']?['name'],
            artUri: Uri.parse(song['thumbnails']
                ?.first['url']
                .replaceAll('w60-h60', 'w225-h225')),
            artist: song['artists']?.map((artist) => artist['name']).join(','),
            extras: song,
          ),
        ),
      );
      _player.play();
      if (autoFetch == true && song['status'] != 'DOWNLOADED') {
        List nextSongs =
            await GetIt.I<YTMusic>().getNextSongList(videoId: song['videoId']);
        nextSongs.removeAt(0);
        await _addSongListToQueue(nextSongs);
      }
    }
  }

  Future<void> playNext(Map<String, dynamic> song) async {
    if (song['videoId'] != null) {
      Uri uri = Uri.parse(song['status'] == 'DOWNLOADED' &&
              song['path'] != null &&
              (await File(song['path']).exists())
          ? song['path']
          : 'http://$serverAddress?id=${song['videoId']}');
      AudioSource audioSource = AudioSource.uri(
        uri,
        tag: MediaItem(
          id: song['videoId'],
          title: song['title'] ?? 'Title',
          album: song['album']?['name'],
          artUri: Uri.parse(song['thumbnails']
              ?.first['url']
              .replaceAll('w60-h60', 'w225-h225')),
          artist: song['artists']?.map((artist) => artist['name']).join(','),
          extras: song,
        ),
      );

      if (_playlist.length > 0) {
        await _playlist.insert((_player.currentIndex ?? -1) + 1, audioSource);
      } else {
        await _playlist.add(audioSource);
      }
      // pprint(_playlist.children.first);
    } else if (song['playlistId'] != null) {
      List songs =
          await GetIt.I<YTMusic>().getPlaylistSongs(song['playlistId']);
      await _addSongListToQueue(songs, isNext: true);
    }
    if (!_player.playing) {
      _player.play();
    }
  }

  playAll(List songs, {index = 0}) async {
    await _playlist.clear();
    await _addSongListToQueue(songs);
    await _player.seek(Duration.zero, index: index);
    if (!(_player.playing)) _player.play();
  }

  Future<void> addToQueue(Map<String, dynamic> song) async {
    if (song['videoId'] != null) {
      Uri uri = Uri.parse(song['status'] == 'DOWNLOADED' &&
              song['path'] != null &&
              (await File(song['path']).exists())
          ? song['path']
          : 'http://$serverAddress?id=${song['videoId']}');
      await _playlist.add(
        AudioSource.uri(
          uri,
          tag: MediaItem(
            id: song['videoId'],
            title: song['title'] ?? 'Title',
            album: song['album']?['name'],
            artUri: Uri.parse(song['thumbnails']
                ?.first['url']
                .replaceAll('w60-h60', 'w225-h225')),
            artist: song['artists']?.map((artist) => artist['name']).join(','),
            extras: song,
          ),
        ),
      );
    } else if (song['playlistId'] != null) {
      List songs =
          await GetIt.I<YTMusic>().getPlaylistSongs(song['playlistId']);
      await _addSongListToQueue(songs, isNext: false);
    }
  }

  Future<void> startRelated(Map<String, dynamic> song,
      {bool radio = false, bool shuffle = false, bool isArtist = false}) async {
    await _playlist.clear();
    if (!isArtist) {
      await addToQueue(song);
    }
    List songs = await GetIt.I<YTMusic>().getNextSongList(
        videoId: song['videoId'],
        playlistId: song['playlistId'],
        radio: radio,
        shuffle: shuffle);
    songs.removeAt(0);
    await _addSongListToQueue(songs, isNext: false);
    _player.play();
  }

  Future<void> startPlaylistSongs(Map endpoint) async {
    await playlist.clear();
    List songs = await GetIt.I<YTMusic>().getNextSongList(
        playlistId: endpoint['playlistId'], params: endpoint['params']);
    await _addSongListToQueue(songs);
    _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    await _playlist.clear();
    await _player.seek(Duration.zero, index: 0);
    _currentIndex = null;
    _currentSong = null;
    notifyListeners();
  }

  _addSongListToQueue(List songs, {bool isNext = false}) async {
    int index = _playlist.length;
    if (isNext) {
      index = _player.sequence == null || _player.sequence!.isEmpty
          ? 0
          : currentIndex! + 1;
    }

    await _playlist.insertAll(
        index,
        songs.map((song) {
          Uri uri = Uri.parse(
              song['status'] == 'DOWNLOADED' && song['path'] != null
                  ? song['path']
                  : 'http://$serverAddress?id=${song['videoId']}');
          return AudioSource.uri(
            uri,
            tag: MediaItem(
              id: song['videoId'],
              title: song['title'] ?? 'Title',
              album: song['album']?['name'],
              artUri: Uri.parse(song['thumbnails']
                  ?.first['url']
                  .replaceAll('w60-h60', 'w225-h225')),
              artist:
                  song['artists']?.map((artist) => artist['name']).join(','),
              extras: Map.from(song),
            ),
          );
        }).toList());
  }

  setTimer(Duration duration) {
    int seconds = duration.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      _timerDuration.value = Duration(seconds: seconds);
      if (seconds == 0) {
        cancelTimer();
        _player.pause();
      }
      notifyListeners();
    });
  }

  cancelTimer() {
    _timerDuration.value = null;
    _timer?.cancel();
    notifyListeners();
  }
}

enum ButtonState { loading, paused, playing }

enum LoopState { off, all, one }

class ProgressBarState {
  Duration current;
  Duration buffered;
  Duration total;
  ProgressBarState(
      {this.current = Duration.zero,
      this.buffered = Duration.zero,
      this.total = Duration.zero});
}
