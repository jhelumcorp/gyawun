import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImageCacheManager {
  static final _cacheManager = DefaultCacheManager();

  /// Live cache size (in bytes). Listen to this in your UI.
  static final ValueNotifier<double> cacheSize = ValueNotifier(0.0);

  /// Call this once (e.g. in main) to start tracking cache size
  static Future<ValueNotifier<double>> init() async {
    cacheSize.value = await _calculateCacheSize();
    return cacheSize;
  }

  /// Internal: calculate cache size
  static Future<double> _calculateCacheSize() async {
    final store = _cacheManager.store;
    final totalSize = await store.getCacheSize();
    return totalSize / 1024 / 1024;
  }

  /// Public: Refresh and update [cacheSize]
  static Future<void> refreshCacheSize() async {
    cacheSize.value = await _calculateCacheSize();
  }

  static Future<void> resetCache() async {
    await _cacheManager.emptyCache();
    await refreshCacheSize();
  }
}
