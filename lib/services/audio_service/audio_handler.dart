import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: MyAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.sheikhhaziq.gyawun.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
    ),
  );
}

/// Internal audio handler - manages audio_service <-> just_audio bridge
/// Only accessed through MediaPlayer - does NOT expose streams to UI
class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  MyAudioHandler() {
    _player.setAndroidAudioAttributes(
      const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
    );
    _initAudioSession();
    _initPlaybackStateStream();
    _initQueueSync();
    _initMediaItemSync();
    _initErrorLogging();
  }
  final AudioPlayer _player = AudioPlayer(maxSkipsOnError: 6);

  // Internal access for MediaPlayer only
  AudioPlayer get player => _player;

  final _sleepTimerExpiry = BehaviorSubject<DateTime?>.seeded(null);
  Stream<DateTime?> get sleepTimerStream => _sleepTimerExpiry.stream;
  DateTime? get sleepTimerExpiry => _sleepTimerExpiry.value;

  Timer? _sleepTimer;

  // --- Initialization --------------------------------------------------------

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle interruptions (e.g., phone calls)
    // session.interruptionEventStream.listen((event) {
    //   if (event.begin) {
    //     if (playbackState.value.playing) pause();
    //   } else {
    //     if (!playbackState.value.playing && event.type == AudioInterruptionType.pause) {
    //       play();
    //     }
    //   }
    // });

    // Pause when headphones unplug
    session.becomingNoisyEventStream.listen((_) {
      if (playbackState.value.playing) pause();
    });
  }

  void _initPlaybackStateStream() {
    // Combine player events into a single PlaybackState stream
    Rx.combineLatest4<PlaybackEvent, Duration, Duration, Duration?, PlaybackState>(
      _player.playbackEventStream,
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      (event, position, bufferedPosition, duration) {
        final current = mediaItem.valueOrNull;

        // Update mediaItem duration when it becomes available
        if (current != null &&
            duration != null &&
            duration > Duration.zero &&
            current.duration != duration) {
          mediaItem.add(current.copyWith(duration: duration));
        }

        return _transformEvent(
          event,
        ).copyWith(updatePosition: position, bufferedPosition: bufferedPosition);
      },
    ).pipe(playbackState);
  }

  void _initQueueSync() {
    // Keep audio_service queue in sync with player's sequence
    // This is used for notifications and system media controls only
    _player.sequenceStream.listen((sequence) {
      final items = sequence.map((s) => s.tag).whereType<MediaItem>().toList(growable: false);
      queue.add(items);
    });
  }

  void _initMediaItemSync() {
    // Keep mediaItem in sync with player's current index
    _player.currentIndexStream.listen((index) {
      final q = queue.value;
      if (index != null && index >= 0 && index < q.length) {
        mediaItem.add(q[index]);
      } else {
        mediaItem.add(null);
      }
    });
  }

  void _initErrorLogging() {
    _player.errorStream.listen((e) {
      debugPrint('⚠️ Audio player error: $e');
    });
  }

  // --- Playback Controls (audio_service overrides) ---------------------------

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    final sequence = _player.sequence;
    if (index >= 0 && index < sequence.length) {
      await _player.seek(Duration.zero, index: index);
      // Auto-play if not already playing
      if (!_player.playing) {
        play();
      }
    }
  }

  // --- Queue Management ------------------------------------------------------

  /// Remove queue item at index
  @override
  Future<void> removeQueueItemAt(int index) async {
    final sequence = _player.sequence;
    if (index >= 0 && index < sequence.length) {
      await _player.removeAudioSourceAt(index);
    }
  }

  // --- Timer -----------------------------------------------------------------

  /// Start sleep timer (in minutes)
  Future<void> startSleepTimer(int minutes) async {
    cancelSleepTimer();

    final expiry = DateTime.now().add(Duration(minutes: minutes));
    _sleepTimerExpiry.add(expiry);

    _sleepTimer = Timer(Duration(minutes: minutes), () async {
      await stop();
      cancelSleepTimer();
    });
  }

  /// Cancel sleep timer
  Future<void> cancelSleepTimer() async {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerExpiry.add(null);
  }

  // --- State Transformation --------------------------------------------------

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
        MediaAction.setSpeed,
      },
      androidCompactActionIndices: [if (_player.hasPrevious) 0, 1, if (_player.hasNext) 2],
      processingState: _mapProcessingState(event.processingState),
      playing: _player.playing,
      updatePosition: event.updatePosition,
      bufferedPosition: event.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: _mapLoopModeToRepeatMode(_player.loopMode),
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

  AudioServiceRepeatMode _mapLoopModeToRepeatMode(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
    }
  }

  // --- Lifecycle -------------------------------------------------------------

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  Future<void> dispose() async {
    _sleepTimer?.cancel();
    await _sleepTimerExpiry.close();
    await _player.dispose();
  }
}
