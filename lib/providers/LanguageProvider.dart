import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  String _currentLocaleText = "en";
  final SharedPreferences _prefs;

  LanguageProvider(this._prefs) {
    String? locale = _prefs.getString('locale');
    if (locale != null) {
      _currentLocale = Locale(locale);
      _currentLocaleText = locale;
    }
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;
  String get currentLocaleText => _currentLocaleText;

  setLocale(String locale) async {
    _currentLocale = Locale(locale);
    _currentLocaleText = locale;
    _prefs.setString('locale', locale);
    notifyListeners();
  }
}
