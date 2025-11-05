import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagers {
  static final audioCacheManager = CacheManager(
    Config(
      'AudioCache',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 100,
    ),
  );
}
