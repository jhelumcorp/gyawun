import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/cubits/yt_music_cubit.dart';
import 'package:gyawun_music/services/settings/states/yt_music_state.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

/// Represents a sponsor segment in a video
class SponsorSegment {
  SponsorSegment({
    required this.uuid,
    required this.segment,
    required this.category,
    required this.votes,
    required this.videoDuration,
  });

  factory SponsorSegment.fromJson(Map<String, dynamic> json) {
    return SponsorSegment(
      uuid: json['UUID'] as String,
      segment: (json['segment'] as List).map((e) => (e as num).toDouble()).toList(),
      category: json['category'] as String,
      votes: json['votes'] as int,
      videoDuration: (json['videoDuration'] as num).toDouble(),
    );
  }
  final String uuid;
  final List<double> segment; // [startTime, endTime] in seconds
  final String category;
  final int votes;
  final double videoDuration;

  double get startTime => segment[0];
  double get endTime => segment[1];

  @override
  String toString() =>
      'SponsorSegment($category: ${startTime.toStringAsFixed(1)}s - ${endTime.toStringAsFixed(1)}s)';
}

class SponsorBlockService {
  SponsorBlockService(MediaPlayer player, YtMusicCubit settings)
    : _media = player,
      _settings = settings {
    _listenToSettings();
    _listenToCurrentItem();
    _listenToPosition();
  }

  // Inject dependencies
  final MediaPlayer _media;
  final YtMusicCubit _settings;

  static const String _baseUrl = 'https://sponsor.ajay.app/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  final _segments = StreamController<List<SponsorSegment>>.broadcast();
  List<SponsorSegment> _currentSegments = [];
  final Set<String> _skipCategories = {};
  bool _enabled = false;

  // Subscriptions
  StreamSubscription? _settingsSub;
  StreamSubscription? _currentItemSub;
  StreamSubscription? _positionSub;

  /// STREAM OUTPUT
  Stream<List<SponsorSegment>> get segmentsStream => _segments.stream;

  // ------------------------------------------------------
  // 1. Listen to YouTube Music settings cubit
  // ------------------------------------------------------
  void _listenToSettings() {
    _settingsSub = _settings.stream.listen((state) {
      _enabled = state.sponsorBlock;
      _reloadSkipCategories(state);

      // Always refresh segments when settings change
      final item = _media.currentItem;
      if (item != null && item.provider == DataProvider.ytmusic) {
        _fetchFor(item.id);
      }
    });
  }

  void _reloadSkipCategories(YtMusicState s) {
    _skipCategories.clear();
    if (s.sponsorBlockSponsor) _skipCategories.add("sponsor");
    if (s.sponsorBlockSelfpromo) _skipCategories.add("selfpromo");
    if (s.sponsorBlockInteraction) _skipCategories.add("interaction");
    if (s.sponsorBlockIntro) _skipCategories.add("intro");
    if (s.sponsorBlockOutro) _skipCategories.add("outro");
    if (s.sponsorBlockPreview) _skipCategories.add("preview");
    if (s.sponsorBlockMusicOffTopic) _skipCategories.add("music_offtopic");
  }

  // ------------------------------------------------------
  // 2. Listen to MediaPlayer current item → load new segments
  // ------------------------------------------------------
  void _listenToCurrentItem() {
    _currentItemSub = _media.currentItemStream.listen((item) async {
      if (item == null) {
        _segments.add([]);
        return;
      }

      if (item.provider != DataProvider.ytmusic) {
        _segments.add([]);
        return;
      }

      await _fetchFor(item.id);
    });
  }

  Future<void> _fetchFor(String videoId) async {
    try {
      // Fetch ALL categories, not just enabled ones
      final allCategories = [
        "sponsor",
        "selfpromo",
        "interaction",
        "intro",
        "outro",
        "preview",
        "music_offtopic",
      ];

      final catJson = '[${allCategories.map((c) => '"$c"').join(',')}]';

      final res = await _dio.get(
        '/skipSegments',
        queryParameters: {'videoID': videoId, 'categories': catJson},
      );

      if (res.data is List) {
        _currentSegments = (res.data as List).map((e) => SponsorSegment.fromJson(e)).toList();
        _segments.add(_currentSegments);
      }
    } catch (_) {
      _segments.add([]);
    }
  }

  // ------------------------------------------------------
  // 3. Listen to position stream → auto skip (only enabled categories)
  // ------------------------------------------------------
  void _listenToPosition() {
    _positionSub = _media.positionStream.listen((pos) async {
      if (!_enabled) return;
      if (_currentSegments.isEmpty) return;

      final sec = pos.inMilliseconds / 1000.0;

      for (final seg in _currentSegments) {
        // Only skip if this category is enabled
        if (!_skipCategories.contains(seg.category)) continue;

        if (sec >= seg.startTime && sec < seg.endTime) {
          await _media.seek(Duration(milliseconds: (seg.endTime * 1000).toInt()));
          break;
        }
      }
    });
  }

  void dispose() {
    _settingsSub?.cancel();
    _currentItemSub?.cancel();
    _positionSub?.cancel();
    _segments.close();
    _dio.close();
  }
}
