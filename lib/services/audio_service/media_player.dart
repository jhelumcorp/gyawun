import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/color_extractor.dart';
import 'package:gyawun_music/services/audio_service/audio_handler.dart';
import 'package:gyawun_music/services/audio_service/yt_audio_source.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytmusic/mixins/mixins.dart';
import 'package:ytmusic/models/models.dart';
import 'package:ytmusic/yt_music_base.dart';

/// Public-facing media player - wraps MyAudioHandler with convenience methods
class MediaPlayer {
  MediaPlayer(MyAudioHandler audioHandler)
    : _audioHandler = audioHandler,
      _player = audioHandler.player {
    currentItemStream.listen(_updateDominantColorFromMediaItem);
  }
  final MyAudioHandler _audioHandler;
  final AudioPlayer _player;
  final YoutubeExplode _yt = YoutubeExplode();
  AudioPlayer get player => _player;

  // --- State Getters ---------------------------------------------------------

  final _dominantSeedColor = BehaviorSubject<Color?>.seeded(null);

  Stream<Color?> get dominantSeedColorStream => _dominantSeedColor.stream;

  void _updateDominantColorFromMediaItem(IndexedAudioSource? source) async {
    final item = source?.tag as MediaItem?;
    if (item?.artUri == null) return;

    final url = item!.artUri.toString();
    final value = await compute(extractDominantColor, url);
    if (value == null) return;

    _dominantSeedColor.add(Color(value));
  }

  Stream<bool> get hasQueueItemsStream =>
      queueStateStream.map((state) => state.sequence.isNotEmpty);

  /// Current index in queue
  int? get currentIndex => _player.currentIndex;

  /// Current media item
  MediaItem? get currentMediaItem =>
      _player.currentIndex == null ? null : _player.sequence[_player.currentIndex!].tag;

  // --- Streams ---------------------------------------------------------------

  /// Current media item stream
  Stream<IndexedAudioSource?> get currentItemStream => Rx.combineLatest2(
    _player.sequenceStream,
    _player.currentIndexStream,
    (sequence, index) => index == null ? null : sequence[index],
  );

  Stream<MediaItem?> get mediaItemStream => Rx.combineLatest2(
    _player.sequenceStream,
    _player.currentIndexStream,
    (sequence, index) => index == null ? null : sequence[index].tag,
  );

  /// Queue state (queue + current index)
  Stream<SequenceState> get queueStateStream => _player.sequenceStateStream.distinct();

  /// Current index stream
  Stream<int?> get currentIndexStream => _player.currentIndexStream.distinct();

  /// Whether there's a next track
  Stream<bool> get hasNextStream => _player.sequenceStateStream.distinct().map((state) {
    final currentIndex = state.currentIndex;
    if (currentIndex == null) return false;
    return currentIndex < state.sequence.length - 1;
  });

  /// Whether there's a previous track
  Stream<bool> get hasPreviousStream => _player.sequenceStateStream.distinct().map((state) {
    final currentIndex = state.currentIndex;
    if (currentIndex == null) return false;
    return currentIndex > 0;
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

  Stream<(PositionData, MediaItem?)> get positionAndItemStream =>
      Rx.combineLatest2<PositionData, MediaItem?, (PositionData, MediaItem?)>(
        positionDataStream.distinct(),
        mediaItemStream.distinct(),
        (positionData, mediaItem) => (positionData, mediaItem),
      ).distinct();

  /// Song title
  Stream<String> get titleStream => mediaItemStream.map((item) => item?.title ?? '');

  /// Song subtitle (artist)
  Stream<String> get subtitleStream => mediaItemStream.map((item) => item?.artist ?? '');

  /// Thumbnails
  Stream<List<YTThumbnail>> get thumbnailStream =>
      mediaItemStream.map((item) => _extractThumbnails(item));

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
        // H:MM:SS (no leading zero in hours)
        return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      } else {
        // MM:SS
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

  Future<void> skipToIndex(int index) async {
    print('=== skipToIndex called ===');
    print('Target index: $index');
    print('Current index BEFORE: ${_player.currentIndex}');
    print('Sequence length: ${_player.sequence.length}');

    await _player.seek(Duration.zero, index: index);

    print('Current index AFTER seek: ${_player.currentIndex}');

    _player.play();

    print('Current index AFTER play: ${_player.currentIndex}');
    print('======================');
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  /// Set loop mode
  Future<void> setLoopMode(LoopMode loopMode) => _player.setLoopMode(loopMode);

  /// Set shuffle mode
  Future<void> setShuffleModeEnabled(bool enabled) => _player.setShuffleModeEnabled(enabled);

  // --- Queue Management ------------------------------------------------------

  /// Play a single YouTube item immediately (replaces queue)
  Future<void> playYTSong(YTItem item) async {
    if (!_isPlayableItem(item)) return;
    final mediaItem = _mediaItemFromYT(item);

    // Replace queue with new song
    await _player.setAudioSource(_createAudioSource(mediaItem));
    _player.play(); // ✅ Added await

    // Get and add related songs to queue
    final songs = await sl<YTMusic>().getNextSongs(body: item.endpoint);
    if (songs.isNotEmpty) {
      songs.removeAt(0); // Remove duplicate of current song
      // Add remaining songs to queue
      for (var song in songs.where(_isPlayableItem)) {
        final mediaItem = _mediaItemFromYT(song);
        await _player.addAudioSource(_createAudioSource(mediaItem));
      }
    }
  }

  /// Add YouTube items to queue and play first one
  Future<void> playYTSongs(List<YTItem> items) async {
    final mediaItems = items.where(_isPlayableItem).map(_mediaItemFromYT).toList();

    if (mediaItems.isEmpty) return;

    // Set first song as audio source
    final first = mediaItems.removeAt(0);
    await _player.setAudioSource(_createAudioSource(first));
    _player.play(); // ✅ Added await

    // Add remaining songs to queue
    for (var item in mediaItems) {
      await _player.addAudioSource(_createAudioSource(item));
    }
  }

  Future<void> playYTRadio(YTItem item) async {
    if (!_isPlayableItem(item)) return;
    final mediaItem = _mediaItemFromYT(item);

    // Replace queue with new song
    await _player.setAudioSource(_createAudioSource(mediaItem));
    _player.play(); // ✅ Added await

    // Get and add radio songs to queue
    if (item is HasRadioEndpoint && item.radioEndpoint != null) {
      final songs = await sl<YTMusic>().getNextSongs(body: item.radioEndpoint!);
      if (songs.isNotEmpty) {
        songs.removeAt(0); // Remove duplicate of current song
        // Add remaining songs to queue
        for (var song in songs.where(_isPlayableItem)) {
          final mediaItem = _mediaItemFromYT(song);
          await _player.addAudioSource(_createAudioSource(mediaItem));
        }
      }
    }
  }

  Future<void> playYTFromEndpoint(Map<String, dynamic> endpoint) async {
    final songs = await sl<YTMusic>().getNextSongs(body: endpoint);
    if (songs.isEmpty) return;

    final playableSongs = songs.where(_isPlayableItem).toList();
    if (playableSongs.isEmpty) return;

    // Set first song as audio source
    final first = playableSongs.removeAt(0);
    final firstMediaItem = _mediaItemFromYT(first);
    await _player.setAudioSource(_createAudioSource(firstMediaItem));
    _player.play(); // ✅ Added await

    // Add remaining songs to queue
    for (var song in playableSongs) {
      final mediaItem = _mediaItemFromYT(song);
      await _player.addAudioSource(_createAudioSource(mediaItem));
    }
  }

  /// Add YouTube item to play next (after current song)
  Future<void> playYTNext(YTItem item) async {
    if (!_isPlayableItem(item)) return;
    final mediaItem = _mediaItemFromYT(item);

    // ✅ Better handling of insertion position
    final currentIdx = _player.currentIndex ?? -1;
    final insertAt = (currentIdx + 1).clamp(0, _player.sequence.length);

    await _player.insertAudioSource(insertAt, _createAudioSource(mediaItem));
  }

  /// Add YouTube item to end of queue
  Future<void> addYTToQueue(YTItem item) async {
    if (!_isPlayableItem(item)) return;
    final mediaItem = _mediaItemFromYT(item);
    await _player.addAudioSource(_createAudioSource(mediaItem));
  }

  /// Remove item from queue at index
  Future<void> removeAt(int index) => _player.removeAudioSourceAt(index);

  /// Move item in queue
  Future<void> moveItem(int currentIndex, int newIndex) =>
      _player.moveAudioSource(currentIndex, newIndex);

  /// Clear queue and stop playback
  Future<void> clearQueue() async {
    await stop();
    // Queue will be cleared when player stops
  }

  /// Player settings
  Future<void> setSkipSilenceEnabled(bool enabled) => _player.setSkipSilenceEnabled(enabled);

  // --- Helper Methods --------------------------------------------------------

  bool _isPlayableItem(YTItem item) {
    return item is YTSong || item is YTVideo || item is YTEpisode;
  }

  MediaItem _mediaItemFromYT(YTItem item) {
    final album = item is HasAlbum ? item.album?.title : null;
    final artists = item is HasArtists
        ? item.artists.map((artist) => artist.title).join(', ')
        : null;
    final thumbnail = item is HasThumbnail && item.thumbnails.lastOrNull?.url != null
        ? Uri.parse(item.thumbnails.last.url)
        : null;

    return MediaItem(
      id: item.id,
      title: item.title,
      displayTitle: item.title,
      album: album,
      artist: artists,
      artUri: thumbnail,
      extras: {
        'id': item.id,
        'title': item.title,
        'subtitle': item.subtitle,
        'album': _serializeAlbum(item),
        'artists': _serializeArtists(item),
        'endpoint': item.endpoint,
        'radioEndpoint': _serializeRadioEndpoint(item),
        'shuffleEndpoint': _serializeShuffleEndpoint(item),
        'thumbnails': _serializeThumbnails(item),
      },
    );
  }

  // Serialize custom objects to JSON-compatible maps/lists
  Map<String, dynamic>? _serializeAlbum(YTItem item) {
    if (item is! HasAlbum || item.album == null) return null;
    return {'title': item.album!.title, 'id': item.album!.id, 'endpoint': item.album!.endpoint};
  }

  List<Map<String, dynamic>>? _serializeArtists(YTItem item) {
    if (item is! HasArtists) return null;
    return item.artists
        .map((artist) => {'title': artist.title, 'id': artist.id, 'endpoint': artist.endpoint})
        .toList();
  }

  Map<String, dynamic>? _serializeRadioEndpoint(YTItem item) {
    if (item is! HasRadioEndpoint) return null;
    return item.radioEndpoint;
  }

  Map<String, dynamic>? _serializeShuffleEndpoint(YTItem item) {
    if (item is! HasShuffleEndpoint) return null;
    return item.shuffleEndpoint;
  }

  List<Map<String, dynamic>>? _serializeThumbnails(YTItem item) {
    if (item is! HasThumbnail) return null;
    return item.thumbnails
        .map(
          (thumbnail) => {
            'url': thumbnail.url,
            'width': thumbnail.width,
            'height': thumbnail.height,
          },
        )
        .toList();
  }

  // Extract thumbnails from MediaItem extras
  List<YTThumbnail> _extractThumbnails(MediaItem? item) {
    if (item?.extras?['thumbnails'] == null) return [];

    final thumbnailList = item!.extras!['thumbnails'] as List;
    return thumbnailList
        .map(
          (thumbnail) => YTThumbnail(
            url: thumbnail['url'],
            width: thumbnail['width'],
            height: thumbnail['height'],
          ),
        )
        .toList();
  }

  AudioSource _createAudioSource(MediaItem item) {
    return YouTubeAudioSource(item.id, yt: _yt, tag: item);
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
