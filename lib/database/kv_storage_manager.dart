import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/database/kv_storage/kv_key_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KVStorageManager {
  KVStorageManager._(); // private constructor
  static final instance = KVStorageManager._();

  /// Providers for per-key reactive updates
  final Map<String, StateNotifierProvider<KVKeyNotifier<dynamic>, dynamic>>
  _providers = {};

  StateNotifierProvider<KVKeyNotifier<T>, T?> provider<T>(String key) {
    if (_providers.containsKey(key)) {
      return _providers[key]! as StateNotifierProvider<KVKeyNotifier<T>, T?>;
    } else {
      final provider =
          StateNotifierProvider.family<KVKeyNotifier<T>, T?, String>(
            (ref, k) => KVKeyNotifier<T>(k),
          )(key);
      _providers[key] =
          provider as StateNotifierProvider<KVKeyNotifier<dynamic>, dynamic>;
      return provider;
    }
  }

  /// Synchronous helper functions (optional)
  Future<void> setString(String key, String value) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setString(key, value),
      );

  Future<String?> getString(String key) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.getString(key),
      );

  Future<void> setBool(String key, bool value) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool(key, value),
      );

  Future<bool?> getBool(String key) async =>
      await SharedPreferences.getInstance().then((prefs) => prefs.getBool(key));

  Future<void> setInt(String key, int value) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setInt(key, value),
      );

  Future<int?> getInt(String key) async =>
      await SharedPreferences.getInstance().then((prefs) => prefs.getInt(key));

  Future<void> setDouble(String key, double value) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setDouble(key, value),
      );

  Future<double?> getDouble(String key) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.getDouble(key),
      );

  Future<void> setStringList(String key, List<String> value) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setStringList(key, value),
      );

  Future<List<String>?> getStringList(String key) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.getStringList(key),
      );

  Future<void> remove(String key) async =>
      await SharedPreferences.getInstance().then((prefs) => prefs.remove(key));
}
