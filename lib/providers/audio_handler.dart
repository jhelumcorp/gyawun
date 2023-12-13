import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/utils/history.dart';
import 'package:gyawun/utils/playback_cache.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';

Box box = Hive.box('favorites');

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.webyte.gyavun.audio',
      androidNotificationChannelName: 'Gyavun Audio Service',
      androidShowNotificationBadge: true,
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      // androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      notificationColor: Colors.grey[900],
    ),
  );
}

extension AudioHandlerExtension on AudioHandler {
  setShuffle(bool enabled) => customAction('setShuffle', {'enabled': enabled});
  move(int oldIndex, int newIndex) =>
      customAction('move', {'oldIndex': oldIndex, 'newIndex': newIndex});
  clear() => customAction('clear');
  playNext(AudioSource song) => customAction('playNext', {'song': song});
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _equalizer = AndroidEqualizer();
  final _loudnessEnhancer = AndroidLoudnessEnhancer();
  AndroidEqualizerParameters? _equalizerParams;

  late AudioPlayer _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    if (Platform.isAndroid) {
      final AudioPipeline pipeline = AudioPipeline(
        androidAudioEffects: [
          _equalizer,
          _loudnessEnhancer,
        ],
      );
      _player = AudioPlayer(audioPipeline: pipeline);
    } else {
      _player = AudioPlayer();
    }
    GetIt.I.registerSingleton<AudioPlayer>(_player);
    GetIt.I.registerSingleton<AndroidEqualizer>(_equalizer);
    GetIt.I.registerSingleton<AndroidLoudnessEnhancer>(_loudnessEnhancer);

    if (Platform.isAndroid) {
      _loadEquilizer();
    }
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
    box.listenable().addListener(() {
      _notifyAudioHandlerAboutPlaybackEvents();
    });
  }

  _loadEquilizer() async {
    await _loudnessEnhancer.setEnabled(Hive.box('settings')
        .get('loudnessEnabled', defaultValue: false) as bool);
    await _loudnessEnhancer
        .setTargetGain(Hive.box('settings').get('loudness', defaultValue: 0.0));

    await _equalizer.setEnabled(Hive.box('settings')
        .get('equalizerEnabled', defaultValue: false) as bool);
    _equalizer.parameters.then((value) async {
      _equalizerParams ??= value;

      final List<AndroidEqualizerBand> bands = _equalizerParams!.bands;
      await Future.forEach(
        bands,
        (e) {
          final gain = Hive.box('settings')
              .get('equalizerBand${e.index}', defaultValue: 0.0) as double;
          _equalizerParams!.bands[e.index].setGain(gain);
        },
      );
    });
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);

      if (Platform.isAndroid) _player.setPreferredPeakBitRate(320);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;

      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (mediaItem.value?.id != null)
            box.get(mediaItem.value?.id) != null
                ? MediaControl.rewind
                : MediaControl.fastForward,
          if (_player.hasPrevious) MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          if (_player.hasNext) MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.playPause,
          MediaAction.skipToNext,
          MediaAction.skipToPrevious,
        },
        androidCompactActionIndices: const [1, 2, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) async {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      if (index != 0) {
        await addSongHistory(playlist[index].extras!);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      List<IndexedAudioSource>? sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    List<UriAudioSource> items = [];
    await Future.forEach(mediaItems,
        (element) async => items.add(await _createAudioSource(element)));
    if (Platform.isLinux) {
      _playlist = ConcatenatingAudioSource(children: items);
      await _player.setAudioSource(_playlist);
    } else {
      await _playlist.addAll(items);
    }
    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = await _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  Future<UriAudioSource> _createAudioSource(MediaItem mediaItem) async {
    String? u =
        await GetIt.I<PlaybackCache>().getFile(url: mediaItem.extras!['url']);
    return AudioSource.uri(
      Uri.parse(u ?? mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);
    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> rewind() async {
    if (mediaItem.value?.id != null) await box.delete(mediaItem.value?.id);
  }

  @override
  Future<void> fastForward() async {
    if (mediaItem.value?.id != null) {
      await box.put(mediaItem.value?.id, mediaItem.value?.extras);
    }
  }

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  Timer? _sleepTimer;
  ValueNotifier<Duration?> sleepTimer = ValueNotifier(null);
  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    } else if (name == 'setShuffle') {
      bool enabled = extras!['enabled'];
      await _player.setShuffleModeEnabled(enabled);
    } else if (name == 'move') {
      await _playlist.move(extras!['oldIndex'], extras['newIndex']);
    } else if (name == 'clear') {
      await _playlist.clear();
      queue.add([]);
    } else if (name == 'playNext') {
      List similatItems = _playlist.sequence
          .where((e) => e.tag.id == extras?['song'].tag.id)
          .toList();
      if (similatItems.isNotEmpty) {
        int i = _playlist.sequence.indexOf(similatItems.first);
        await _playlist.removeAt(i);
      }

      int cIndex = _player.currentIndex ?? -1;
      cIndex++;
      if (_playlist.length == 0) {
        cIndex = 0;
      }
      _playlist.insert(cIndex, extras?['song']);
    }
  }

  @override
  Future<void> onNotificationDeleted() {
    stop();

    return super.onNotificationDeleted();
  }

  @override
  Future<void> onTaskRemoved() {
    stop();

    return super.onTaskRemoved();
  }

  @override
  Future<void> stop() async {
    await _playlist.clear();
    queue.add([]);
    await _player.stop();
    _sleepTimer?.cancel();
    await super.stop();
    GetIt.I<MediaManager>().stopPlayer();
  }
}
