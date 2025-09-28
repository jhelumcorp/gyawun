import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Generic per-key StateNotifier
class KVKeyNotifier<T> extends StateNotifier<T?> {
  final String key;
  KVKeyNotifier(this.key) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    T? value;

    if (T == bool) {
      value = prefs.getBool(key) as T?;
    } else if (T == int) {
      value = prefs.getInt(key) as T?;
    } else if (T == double) {
      value = prefs.getDouble(key) as T?;
    } else if (T == String) {
      value = prefs.getString(key) as T?;
    } else if (T == List<String>) {
      value = prefs.getStringList(key) as T?;
    } else {
      throw Exception('Unsupported type');
    }
    state = value;
  }

  Future<void> set(T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported type');
    }
    state = value;
  }

  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    state = null;
  }
}
