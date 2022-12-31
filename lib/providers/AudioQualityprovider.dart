import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioQualityProvider extends ChangeNotifier {
  String _quality = 'medium';
  final SharedPreferences _prefs;

  AudioQualityProvider(this._prefs) {
    String quality = _prefs.getString('audioQuality') ?? 'medium';
    _quality = quality;
    notifyListeners();
  }

  get quality => _quality;

  setQuality(quality) {
    _prefs.setString('audioQuality', quality);
    _quality = quality;
    notifyListeners();
  }
}
