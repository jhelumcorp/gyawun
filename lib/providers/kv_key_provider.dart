import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/database/kv_storage/kv_key_notifier.dart';

// Bool key provider (nullable)
final boolKeyProvider =
    StateNotifierProvider.family<KVKeyNotifier<bool>, bool?, String>(
      (ref, key) => KVKeyNotifier<bool>(key),
    );

// Int key provider (nullable)
final intKeyProvider =
    StateNotifierProvider.family<KVKeyNotifier<int>, int?, String>(
      (ref, key) => KVKeyNotifier<int>(key),
    );

// Double key provider (nullable)
final doubleKeyProvider =
    StateNotifierProvider.family<KVKeyNotifier<double>, double?, String>(
      (ref, key) => KVKeyNotifier<double>(key),
    );

// String key provider (nullable)
final stringKeyProvider =
    StateNotifierProvider.family<KVKeyNotifier<String?>, String?, String>(
      (ref, key) => KVKeyNotifier<String?>(key),
    );

// List<String> key provider (nullable)
final stringListKeyProvider =
    StateNotifierProvider.family<
      KVKeyNotifier<List<String>?>,
      List<String>?,
      String
    >((ref, key) => KVKeyNotifier<List<String>?>(key));
