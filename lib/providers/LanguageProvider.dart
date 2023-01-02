import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  TextDirection _textDirection = TextDirection.ltr;
  String _currentLocaleText = "en";
  final SharedPreferences _prefs;

  LanguageProvider(this._prefs) {
    String? locale = _prefs.getString('locale');
    String? textDirection = _prefs.getString('textDirection');
    if (locale != null) {
      _currentLocale = Locale(locale);
      _currentLocaleText = locale;
    }
    if (textDirection != null) {
      _textDirection =
          textDirection == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
    }
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;
  String get currentLocaleText => _currentLocaleText;
  TextDirection get textDirection => _textDirection;

  setLocale(String locale) async {
    _currentLocale = Locale(locale);
    _currentLocaleText = locale;
    _prefs.setString('locale', locale);
    notifyListeners();
  }

  setTextDirection(textDirection) {
    _textDirection =
        textDirection == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
    notifyListeners();
    _prefs.setString('textDirection', textDirection);
  }
}
