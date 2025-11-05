import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/services/audio_service/yt_audio_source.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.sheikhhaziq.gyawun.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

/// Custom AudioHandler that bridges audio_service and just_audio.
class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer(maxSkipsOnError: 6);

  /// A stream that broadcasts the current queue state.
  Stream<QueueState> get queueStateStream =>
      Rx.combineLatest2<List<int>?, List<MediaItem>, QueueState>(
        _player.shuffleIndicesStream.map((indices) => indices.toList()),
        queue,
        (shuffleIndices, queue) =>
            QueueState(queue: queue, shuffleIndices: shuffleIndices),
      ).distinct();

  MyAudioHandler() {
    _initAudioSession();

    // Combine event + position + buffered + duration → single PlaybackState stream
    Rx.combineLatest4<
          PlaybackEvent,
          Duration,
          Duration,
          Duration?,
          PlaybackState
        >(
          _player.playbackEventStream,
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (event, position, bufferedPosition, duration) {
            // Update MediaItem duration dynamically
            final currentItem = mediaItem.value;
            if (currentItem != null &&
                duration != null &&
                currentItem.duration != duration) {
              mediaItem.add(currentItem.copyWith(duration: duration));
            }

            // Map playback data to PlaybackState
            return _transformEvent(event).copyWith(
              updatePosition: position,
              bufferedPosition: bufferedPosition,
            );
          },
        )
        .pipe(playbackState);

    // Log errors for debugging
    _player.errorStream.listen((error) {
      debugPrint("⚠️ just_audio error: $error");
    });

    // Keep mediaItem in sync with current index
    _player.currentIndexStream.listen((index) {
      final currentQueue = queue.value;
      if (index != null && index < currentQueue.length) {
        mediaItem.add(currentQueue[index]);
      }
    });

    // Keep queue in sync with sequence changes
    _player.sequenceStream.listen((sequence) {
      final newQueue = sequence.map((s) => s.tag as MediaItem).toList();
      queue.add(newQueue);
    });
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio interruptions (calls, etc.)
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (playbackState.value.playing) pause();
      } else {
        if (!playbackState.value.playing) play();
      }
    });

    // Pause on unplugging headphones
    session.becomingNoisyEventStream.listen((_) {
      if (playbackState.value.playing) pause();
    });
  }

  // --- Helpers ---
  AudioSource _createAudioSource(MediaItem mediaItem) =>
      YouTubeAudioSource(mediaItem.id, tag: mediaItem);

  // --- Playback Controls ---
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> stop() => _player.stop();

  // --- Queue Management ---
  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    await _player.addAudioSource(_createAudioSource(mediaItem));
    queue.add([...queue.value, mediaItem]);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    await _player.addAudioSources(mediaItems.map(_createAudioSource).toList());
    queue.add([...queue.value, ...mediaItems]);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _player.removeAudioSourceAt(index);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode != AudioServiceShuffleMode.none;
    await _player.setShuffleModeEnabled(enabled);
    if (enabled) _player.shuffle();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  // --- Custom Playback ---
  Future<void> playSong(MediaItem mediaItem) async {
    await _player.setAudioSource(_createAudioSource(mediaItem));
    this.mediaItem.add(mediaItem);
    await play();
  }

  Future<void> playNext(MediaItem mediaItem) async {
    final insertIndex = (_player.currentIndex ?? 0) + 1;

    await _player.insertAudioSource(insertIndex, _createAudioSource(mediaItem));

    // Update the queue so the UI stays in sync
    final updatedQueue = [...queue.value];
    updatedQueue.insert(insertIndex, mediaItem);
    queue.add(updatedQueue);
  }

  Future<void> playSongs(List<MediaItem> mediaItems) async {
    await _player.setAudioSources(mediaItems.map(_createAudioSource).toList());
    if (mediaItems.isNotEmpty) mediaItem.add(mediaItems.first);
    await play();
  }

  // --- Transform just_audio → audio_service state ---
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.hasPrevious) MediaControl.skipToPrevious,
        if (_player.playing)
          MediaControl.pause.copyWith(androidIcon: 'drawable/ic_pause')
        else
          MediaControl.play.copyWith(androidIcon: 'drawable/ic_play'),
        if (_player.hasNext) MediaControl.skipToNext,
        MediaControl.stop.copyWith(androidIcon: 'drawable/ic_stop'),
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: [
        if (_player.hasPrevious) 0,
        1,
        if (_player.hasNext) 2,
      ],
      processingState: _mapProcessingState(_player.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }
}

/// Represents the current queue and shuffle state.
class QueueState {
  final List<MediaItem> queue;
  final List<int>? shuffleIndices;

  const QueueState({required this.queue, this.shuffleIndices});

  bool get hasPrevious => (shuffleIndices ?? queue).isNotEmpty;
  bool get hasNext => (shuffleIndices ?? queue).isNotEmpty;
}
