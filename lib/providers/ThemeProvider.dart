import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  PrimaryColor _primaryColor = PrimaryColor(
      light: const Color(0xffb9f6ca), dark: const Color(0xff00c853));
  String _themeMode = "light";
  bool _dynamicThemeMode = false;
  ThemeData _currentTheme = _lightTheme;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    String? thememode = _prefs.getString('themeMode');
    bool? dynamicThemeMode = _prefs.getBool('dynamicThemeMode');

    Color primaryColorLight = Color(
        _prefs.getInt('primaryColorLight') ?? const Color(0xffb9f6ca).value);
    Color primaryColorDark = Color(
        _prefs.getInt('primaryColorDark') ?? const Color(0xff00c853).value);

    _themeMode = thememode ?? "light";
    _dynamicThemeMode = dynamicThemeMode ?? false;

    _currentTheme = _themeMode == "light" ? lightTheme : darkTheme;
    _primaryColor =
        PrimaryColor(light: primaryColorLight, dark: primaryColorDark);
  }
  ThemeData get theme => _currentTheme;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  bool get dynamicThemeMode => _dynamicThemeMode;
  ThemeMode get themeMode =>
      _themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  PrimaryColor get primaryColor => _primaryColor;

  setDynamicThemeMode(bool dynamicThemeMode) {
    _dynamicThemeMode = dynamicThemeMode;
    notifyListeners();
    _prefs.setBool('dynamicThemeMode', dynamicThemeMode);
  }

  setTheme(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
    if (themeMode == 'dark') {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }
    _prefs.setString('themeMode', themeMode);
  }

  setPrimaryColor(PrimaryColor primaryColor) {
    _primaryColor = primaryColor;
    _prefs.setInt('primaryColorLight', primaryColor.light.value);
    _prefs.setInt('primaryColorDark', primaryColor.dark.value);
    notifyListeners();
  }
}

ThemeData _lightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  sliderTheme: SliderThemeData(
    trackHeight: 3,
    trackShape: const RoundedRectSliderTrackShape(),
    overlayShape: SliderComponentShape.noOverlay,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
    activeTrackColor: Colors.black,
    thumbColor: Colors.black,
    inactiveTrackColor: Colors.black.withOpacity(0.4),
  ),
);

ThemeData _darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 34, 34, 34),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  sliderTheme: SliderThemeData(
    trackHeight: 3,
    trackShape: const RoundedRectSliderTrackShape(),
    overlayShape: SliderComponentShape.noOverlay,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
    activeTrackColor: Colors.white,
    thumbColor: Colors.white,
    inactiveTrackColor: Colors.white.withOpacity(0.4),
  ),
);

class PrimaryColor {
  Color light;
  Color dark;
  PrimaryColor({
    required this.light,
    required this.dark,
  });

  PrimaryColor copyWith({
    Color? light,
    Color? dark,
  }) {
    return PrimaryColor(
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'light': light.value,
      'dark': dark.value,
    };
  }

  factory PrimaryColor.fromMap(Map<String, dynamic> map) {
    return PrimaryColor(
      light: Color(map['light'] as int),
      dark: Color(map['dark'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrimaryColor.fromJson(String source) =>
      PrimaryColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PrimaryColor(light: $light, dark: $dark)';

  @override
  bool operator ==(covariant PrimaryColor other) {
    if (identical(this, other)) return true;

    return other.light == light && other.dark == dark;
  }

  @override
  int get hashCode => light.hashCode ^ dark.hashCode;
}
