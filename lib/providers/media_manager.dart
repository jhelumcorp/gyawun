import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/api/api.dart';
import 'package:gyawun/api/ytmusic.dart';
import 'package:gyawun/providers/audio_handler.dart';
import 'package:gyawun/utils/downlod.dart';
import 'package:gyawun/utils/history.dart';
import 'package:gyawun/utils/lyrics.dart';
import 'package:just_audio/just_audio.dart';

class MediaManager extends ChangeNotifier {
  final _audioHandler = GetIt.I<AudioHandler>();

  List<MediaItem> songs = [];
  MediaItem? currentSong;
  int index = 0;
  ButtonState buttonState = ButtonState.loading;
  ProgressBarState progressBarState = ProgressBarState();
  bool playing = false;
  bool isShuffleModeEnabled = false;
  LoopState loopState = LoopState.off;
  Duration? timerDuration;
  Timer? _timer;
  Lyrics lyrics = Lyrics();

  MediaManager() {
    init();
  }

  void init() async {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    _listenToShuffle();
  }

  void _listenToChangesInPlaylist() async {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        songs = [];
        currentSong = null;
      } else {
        songs = playlist;

        currentSong ??= (songs.length > index) ? songs[index] : null;
      }
      notifyListeners();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        buttonState = ButtonState.loading;
      } else if (!isPlaying) {
        buttonState = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonState = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      notifyListeners();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      notifyListeners();
    });
  }

  void _listenToBufferedPosition() async {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
      notifyListeners();
    });
  }

  void _listenToTotalDuration() async {
    _audioHandler.mediaItem.listen((mediaitem) {
      final oldState = progressBarState;
      progressBarState = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaitem?.duration ?? Duration.zero,
      );
      notifyListeners();
    });
  }

  void _listenToShuffle() {
    _audioHandler.customEvent.listen((event) {});
  }

  void _listenToChangesInSong() async {
    _audioHandler.mediaItem.listen((mediaItem) {
      if (currentSong != mediaItem) {
        currentSong = mediaItem;
        index = mediaItem != null
            ? _audioHandler.queue.value.indexOf(mediaItem)
            : 0;
      }
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  Future<void> seek(Duration position, {int? index}) async {
    if (index != null) {
      await _audioHandler.skipToQueueItem(index);
    }
    await _audioHandler.seek(position);
    notifyListeners();
  }

  void loop() {
    switch (loopState) {
      case LoopState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        loopState = LoopState.all;
        break;
      case LoopState.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        loopState = LoopState.one;
        break;
      case LoopState.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        loopState = LoopState.off;
        break;
    }
    notifyListeners();
  }

  void shuffle() {
    bool enabled = isShuffleModeEnabled;

    if (enabled) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    }
    isShuffleModeEnabled = !enabled;
    notifyListeners();
  }

  Future<void> previous() async => await _audioHandler.skipToPrevious();
  Future<void> next() async => await _audioHandler.skipToNext();

  Future<void> move(int oldIndex, int newIndex) async {
    await _audioHandler.move(oldIndex, newIndex);
  }

  Future<void> remove(int index) async {
    await _audioHandler.removeQueueItemAt(index);
  }

  Future<void> addItems(List mediaItems) async {
    List<MediaItem> items = [];

    await Future.forEach(mediaItems, (element) async {
      if (element['id'] == null) {
        return;
      }
      MediaItem p = await processSong(element);
      if (_audioHandler.queue.value
          .where((el) => el.id == p.id)
          .toList()
          .isEmpty) {
        items.add(p);
      }
    });

    await _audioHandler.addQueueItems(items);
  }

  Future<void> playNext(Map song) async {
    MediaItem mediaItem = await processSong(song);
    AudioSource audioSource = mediaItem.extras?['offline'] == true
        ? AudioSource.file(mediaItem.extras?['url'], tag: mediaItem)
        : AudioSource.uri(Uri.parse(mediaItem.extras?['url']), tag: mediaItem);

    await _audioHandler.playNext(audioSource);
  }

  Future<void> addAndPlay(List mediaItems,
      {int initialIndex = 0, bool autoFetch = true}) async {
    if (isShuffleModeEnabled) {
      shuffle();
    }
    if (_audioHandler.queue.value.isNotEmpty) {
      await _audioHandler.clear();
    }
    index = initialIndex;
    await addSongHistory(mediaItems[initialIndex]);
    await addItems(mediaItems);

    await seek(Duration.zero, index: initialIndex);
    currentSong = songs[initialIndex];
    _audioHandler.play();
    if (mediaItems.length < 10 && autoFetch) {
      List s = [];
      if (mediaItems[initialIndex]['provider'] == 'youtube') {
        s = await YtMusicService().getWatchPlaylist(
            videoId: mediaItems[initialIndex]['id']
                .toString()
                .replaceAll('youtube', ''));
      } else {
        s = await SaavnAPI().getReco(mediaItems[initialIndex]['id']);
      }
      addItems(s);
    }
  }

  Future<void> addAndPlayYoutube(List mediaItems) async {}

  Future<void> playRadio(item) async {
    String? stationId = await SaavnAPI().createRadio(
      names: item['more_info']['featured_station_type'].toString() == 'artist'
          ? [item['more_info']['query'].toString()]
          : [item['id'].toString()],
      language: item['more_info']['language']?.toString() ?? 'hindi',
      stationType: item['more_info']['featured_station_type'].toString(),
    );
    if (stationId == null) return;
    List songs = await SaavnAPI().getRadioSongs(stationId: stationId);
    await addAndPlay(songs);
  }

  setTimer(Duration duration) {
    int seconds = duration.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      timerDuration = Duration(seconds: seconds);
      if (seconds == 0) {
        cancelTimer();
        pause();
      }
      notifyListeners();
    });
  }

  cancelTimer() {
    timerDuration = null;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _audioHandler.customAction('dispose');
  }

  Future<void> stop() async {
    await _audioHandler.stop();
  }

  void stopPlayer() {
    currentSong = null;
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
