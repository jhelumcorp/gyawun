import 'package:flutter/material.dart';
import 'package:gyawun/api/extensions.dart';
import 'package:gyawun/ui/colors.dart' as ui_colors;
import 'package:gyawun/ui/themes/dark.dart';
import 'package:gyawun/ui/themes/light.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box box = Hive.box('settings');
String tm = box.get('themeMode', defaultValue: 'system');
ThemeMode mode = tm == 'dark'
    ? ThemeMode.dark
    : tm == 'light'
        ? ThemeMode.light
        : ThemeMode.system;

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = mode;
  ThemeMode _effectiveThemeMode = ThemeMode.system;
  Color _accentColor =
      Color(box.get('accentColor', defaultValue: ui_colors.accentColor.value));
  bool _isPitchBlack = box.get('isPitchBlack', defaultValue: false);
  bool _isMaterialTheme = box.get('isMaterialTheme', defaultValue: true);
  bool _isRightToLeftDirection =
      box.get('isRightToLeftDirection', defaultValue: false);
  List<String> _languages = box.get('languages', defaultValue: ["English"]);
  String _language = box.get('language', defaultValue: 'en');

  ThemeManager() {
    init();
  }

  ThemeMode get themeMode => _themeMode;
  ThemeMode get effectiveThemeMode => _effectiveThemeMode;
  Color get accentColor => _accentColor;
  bool get isPitchBlack => _isPitchBlack;
  bool get isMaterialTheme => _isMaterialTheme;
  bool get isRightToLeftDirection => _isRightToLeftDirection;
  List<String> get languages => _languages;
  List<Map<String, dynamic>> get supportedLanguages => [
        {'code': 'ar', 'name': 'arabic'},
        {'code': 'en', 'name': 'english'},
        {'code': 'es', 'name': 'spanish'},
        {'code': 'fr', 'name': 'french'},
        {'code': 'de', 'name': 'german'},
        {'code': 'hi', 'name': 'hindi'},
        // {'code': 'ja', 'name': 'japanese'},
        // {'code': 'ko', 'name': 'korean'},
        {'code': 'ru', 'name': 'russian'},
        {'code': 'tr', 'name': 'turkish'},
        {'code': 'ur', 'name': 'urdu'},
        // {'code': 'zh', 'name': 'chinese'},
      ];
  Map<String, dynamic> get language => {
        'code': _language.toLowerCase(),
        'name': supportedLanguages
            .where((element) =>
                element['code'].toString().toLowerCase() ==
                _language.toLowerCase())
            .first['name']
            .toString()
            .capitalize()
      };

  ThemeData get getLightTheme => lightTheme(_accentColor);

  ThemeData get getDarkTheme =>
      darkTheme(_accentColor, isPitchBlack: _isPitchBlack);

  init() async {
    if (_languages.isEmpty) {
      _languages = ['English'];
    }
    _updateEffectiveThemeMode();
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      _updateEffectiveThemeMode();
    };
  }

  _updateEffectiveThemeMode() {
    bool isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    _effectiveThemeMode =
        (themeMode == ThemeMode.system && isDark) || themeMode == ThemeMode.dark
            ? ThemeMode.dark
            : ThemeMode.light;
    notifyListeners();
  }

  setAccentColor(Color color) {
    box.put('accentColor', color.value);
    _accentColor = color;
    notifyListeners();
  }

  togglePitchBlack() {
    _isPitchBlack = !_isPitchBlack;
    box.put('isPitchBlack', _isPitchBlack);
    notifyListeners();
  }

  toggleMaterialTheme() {
    _isMaterialTheme = !_isMaterialTheme;
    box.put('isMaterialTheme', _isMaterialTheme);
    notifyListeners();
  }

  toggleTextDirection() {
    _isRightToLeftDirection = !isRightToLeftDirection;
    box.put('isRightToLeftDirection', _isRightToLeftDirection);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    box.put('language', code);
    _language = code;
    notifyListeners();
  }

  toggleLanguage(String lang, bool selected) {
    if (selected) {
      _languages.add(lang);
    } else {
      _languages.remove(lang);
    }
    box.put('languages', _languages);
    notifyListeners();
  }

  setThemeMode(ThemeMode mode) {
    String tm = mode == ThemeMode.system
        ? 'system'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'light';
    box.put('themeMode', tm);
    _themeMode = mode;
    _updateEffectiveThemeMode();
  }
}
