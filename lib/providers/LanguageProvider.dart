import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _countryCode = "IN";
  String _countryName = "India";
  Locale _currentLocale = const Locale('en');
  TextDirection _textDirection = TextDirection.ltr;
  String _currentLocaleText = "en";
  final SharedPreferences _prefs;

  LanguageProvider(this._prefs) {
    String? locale = _prefs.getString('locale');
    String? textDirection = _prefs.getString('textDirection');
    String? countryCode = _prefs.getString('countryCode');
    String? countryName = _prefs.getString('countryName');
    if (locale != null) {
      _currentLocale = Locale(locale);
      _currentLocaleText = locale;
    }
    if (textDirection != null) {
      _textDirection =
          textDirection == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
    }
    if (countryCode != null) {
      _countryCode = countryCode;
    }
    if (countryName != null) {
      _countryName = countryName;
    }
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;
  String get currentLocaleText => _currentLocaleText;
  TextDirection get textDirection => _textDirection;
  String get countryCode => _countryCode;
  String get countryName => _countryName;

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

  setCountry({name = "India", code = "IN"}) {
    _countryCode = code;
    _countryName = name;
    notifyListeners();
    _prefs.setString('countryCode', code);
    _prefs.setString('countryName', name);
  }
}
