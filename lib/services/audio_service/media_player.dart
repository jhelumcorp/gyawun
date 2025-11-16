import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/color_extractor.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:gyawun_music/services/audio_service/yt_audio_source.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

/// Public-facing media player with separate queue storage
class MediaPlayer {
  MediaPlayer(MyAudioHandler audioHandler)
    : _audioHandler = audioHandler,
      _player = audioHandler.player {
    currentItemStream.listen(_updateDominantColorSong);
  }

  final MyAudioHandler _audioHandler;
  final AudioPlayer _player;
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();

  // SponsorBlock integration

  // --- Separate Queue Storage ------------------------------------------------

  /// Internal BehaviorSubject holding the queue items
  final _queueItems = BehaviorSubject<List<PlayableItem>>.seeded([]);

  /// Stream of queue items (reactive)
  Stream<List<PlayableItem>> get queueItemsStream => _queueItems.stream;

  /// Current queue items (instant access, synchronous)
  List<PlayableItem> get queueItems => _queueItems.value;

  /// Get item at specific index (instant access)
  PlayableItem? getItemAt(int index) {
    final items = queueItems;
    if (index < 0 || index >= items.length) return null;
    return items[index];
  }

  /// Get current playing item (instant access)
  PlayableItem? get currentItem {
    final index = currentIndex;
    if (index == null) return null;
    return getItemAt(index);
  }

  // --- SponsorBlock Methods --------------------------------------------------

  /// Reload SponsorBlock settings (call this when settings change)

  /// Get current sponsor segments

  // --- State Getters ---------------------------------------------------------

  final _dominantSeedColor = BehaviorSubject<Color?>.seeded(null);
  Stream<Color?> get dominantSeedColorStream => _dominantSeedColor.stream;

  void _updateDominantColorSong(PlayableItem? item) async {
    if (item?.thumbnails == null || item!.thumbnails.isEmpty) return;
    final url = item.thumbnails.first.url;
    final value = await compute(extractDominantColor, url);
    if (value == null) return;
    _dominantSeedColor.add(Color(value));
  }

  Stream<bool> get hasQueueItemsStream => queueItemsStream.map((items) => items.isNotEmpty);

  /// Current index in queue (instant access)
  int? get currentIndex => _player.currentIndex;

  /// Current media item (instant access)
  MediaItem? get currentMediaItem =>
      _player.currentIndex == null ? null : _player.sequence[_player.currentIndex!].tag;

  // --- Streams ---------------------------------------------------------------

  /// Current media item stream
  Stream<PlayableItem?> get currentItemStream => Rx.combineLatest2(
    queueItemsStream,
    _player.currentIndexStream,
    (items, index) => index != null && index < items.length ? items[index] : null,
  );

  Stream<PlayableItem?> get mediaItemStream => currentItemStream;

  /// Current index stream
  Stream<int?> get currentIndexStream => _player.currentIndexStream.distinct();

  Stream<(List<PlayableItem>, int?)> get queueWithIndexStream {
    return Rx.combineLatest2(
      queueItemsStream,
      currentIndexStream,
      (items, index) => (items, index),
    ).distinct();
  }

  /// Whether there's a next track
  Stream<bool> get hasNextStream => queueWithIndexStream.map((state) {
    final (items, index) = state;
    if (index == null) return false;
    return index < items.length - 1;
  });

  /// Whether there's a previous track
  Stream<bool> get hasPreviousStream => currentIndexStream.map((index) {
    if (index == null) return false;
    return index > 0;
  });

  /// Whether player is active (has a current song)
  Stream<bool> get isActiveStream => currentItemStream.map((item) => item != null);

  /// Shuffle mode enabled
  Stream<bool> get shuffleModeEnabledStream => _player.shuffleModeEnabledStream;

  /// Loop mode
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  /// Playback button state (loading/playing/paused)
  Stream<PlaybackButtonState> get playbackStateStream =>
      _player.playerStateStream.distinct().map((state) {
        final processing = state.processingState;
        final playing = state.playing;

        if (processing == ProcessingState.loading || processing == ProcessingState.buffering) {
          return PlaybackButtonState.loading;
        } else if (!playing ||
            processing == ProcessingState.idle ||
            processing == ProcessingState.completed) {
          return PlaybackButtonState.paused;
        } else {
          return PlaybackButtonState.playing;
        }
      });

  /// Position data (position, buffered position, duration)
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream.distinct(),
        _player.bufferedPositionStream.distinct(),
        _player.durationStream.distinct(),
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration),
      ).distinct();

  Stream<(PositionData, PlayableItem?)> get positionAndItemStream =>
      Rx.combineLatest2<PositionData, PlayableItem?, (PositionData, PlayableItem?)>(
        positionDataStream.distinct(),
        mediaItemStream.distinct(),
        (positionData, mediaItem) => (positionData, mediaItem),
      ).distinct();
  Stream<Duration> get positionStream => _player.positionStream;

  /// Song title
  Stream<String> get titleStream => mediaItemStream.map((item) => item?.title ?? '');

  /// Song subtitle (artist)
  Stream<List<Artist>?> get subtitleStream => mediaItemStream.map((item) => item?.artists);

  /// Thumbnails
  Stream<List<Thumbnail>?> get thumbnailStream => mediaItemStream.map((item) => item?.thumbnails);

  Stream<DateTime?> get sleepTimerStream => _audioHandler.sleepTimerStream;
  Stream<String?> get sleepTimerFormattedStream => Rx.combineLatest2<DateTime?, int, String?>(
    sleepTimerStream,
    Stream.periodic(const Duration(seconds: 1), (i) => i),
    (expiry, _) {
      if (expiry == null) return null;

      final diff = expiry.difference(DateTime.now());
      if (diff.isNegative) return null;

      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      final seconds = diff.inSeconds.remainder(60);

      if (hours > 0) {
        return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      } else {
        return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      }
    },
  ).distinct();

  Future<void> startSleepTimer(int minutes) => _audioHandler.startSleepTimer(minutes);
  Future<void> cancelSleepTimer() => _audioHandler.cancelSleepTimer();

  // --- Basic Playback Controls -----------------------------------------------

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> skipToNext() => _player.seekToNext();
  Future<void> skipToPrevious() => _player.seekToPrevious();
  Future<void> skipToIndex(int index) => _player.seek(Duration.zero, index: index);
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  Future<void> setLoopMode(LoopMode loopMode) => _player.setLoopMode(loopMode);
  Future<void> setShuffleModeEnabled(bool enabled) => _player.setShuffleModeEnabled(enabled);

  // --- Queue Management ------------------------------------------------------

  Future<void> playSong(PlayableItem item) async {
    await _player.setAudioSource(await _createAudioSource(item));
    _queueItems.add([item]);
    _player.play();
  }

  Future<void> addSongs(List<PlayableItem> items) async {
    if (items.isEmpty) return;

    final updatedQueue = List<PlayableItem>.from(_queueItems.value);

    for (var item in items) {
      await _player.addAudioSource(await _createAudioSource(item));
      updatedQueue.add(item);
    }

    // Single emit at the end
    _queueItems.add(updatedQueue);
  }

  Future<void> addNext(PlayableItem item) async {
    final updatedQueue = List<PlayableItem>.from(_queueItems.value);

    final index = (_player.currentIndex ?? -1) + 1;
    updatedQueue.insert(index, item);
    _queueItems.add(updatedQueue);
    await _player.insertAudioSource(index, await _createAudioSource(item));
  }

  Future<void> playSongs(List<PlayableItem> items) async {
    final first = items.removeAt(0);
    await _player.setAudioSource(await _createAudioSource(first));
    _player.play();

    for (var item in items) {
      await _player.addAudioSource(await _createAudioSource(item));
    }
    _queueItems.add(items);
  }

  Future<void> addToQueue(PlayableItem item) async {
    final currentQueue = List<PlayableItem>.from(queueItems);
    currentQueue.add(item);
    _queueItems.add(currentQueue);
    await _player.addAudioSource(await _createAudioSource(item));
  }

  /// Remove item from queue at index
  Future<void> removeAt(int index) async {
    await _player.removeAudioSourceAt(index);
    final currentQueue = List<PlayableItem>.from(queueItems);
    currentQueue.removeAt(index);
    _queueItems.add(currentQueue);
  }

  /// Move item in queue from currentIndex to newIndex
  Future<void> moveItem(int currentIndex, int newIndex) async {
    await _player.moveAudioSource(currentIndex, newIndex);
    final currentQueue = List<PlayableItem>.from(queueItems);
    final item = currentQueue.removeAt(currentIndex);
    currentQueue.insert(newIndex, item);
    _queueItems.add(currentQueue);
  }

  Future<void> clearQueue() async {
    _queueItems.add([]);
    await _player.clearAudioSources();
  }

  Future<void> setSkipSilenceEnabled(bool enabled) => _player.setSkipSilenceEnabled(enabled);

  // --- Helper Methods --------------------------------------------------------

  Future<AudioSource> _createAudioSource(PlayableItem item) async {
    final mediaItem = MediaItem(
      id: item.id,
      title: item.title,
      artUri: Uri.parse(item.thumbnails.last.url),
      album: item.album?.name,
      artist: item.artists.map((artist) => artist.name).join(", "),
    );
    if (item.provider == DataProvider.jiosavan) {
      final bitrate = sl<SettingsService>().jioSaavn.state.streamingQuality.bitrate;
      final url = item.downloadItems!.where((e) => e.quality == bitrate).toList().firstOrNull?.url;
      return AudioSource.uri(Uri.parse(url ?? item.downloadItems!.last.url), tag: mediaItem);
    }
    return YouTubeAudioSource(
      item.id,
      yt: _yt,
      audioQuality: sl<SettingsService>().youtubeMusic.state.streamingQuality,
      tag: mediaItem,
    );
  }

  // --- Cleanup ---------------------------------------------------------------

  void dispose() {
    _queueItems.close();
    _dominantSeedColor.close();
  }
}

// --- Data Classes ----------------------------------------------------------

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration? duration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionData &&
          position == other.position &&
          bufferedPosition == other.bufferedPosition &&
          duration == other.duration;

  @override
  int get hashCode => position.hashCode ^ bufferedPosition.hashCode ^ duration.hashCode;
}

enum PlaybackButtonState { loading, playing, paused }
