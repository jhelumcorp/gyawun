// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Add to Queue`
  String get addToQueue {
    return Intl.message(
      'Add to Queue',
      name: 'addToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Songs`
  String get Songs {
    return Intl.message(
      'Songs',
      name: 'Songs',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get Playlists {
    return Intl.message(
      'Playlists',
      name: 'Playlists',
      desc: '',
      args: [],
    );
  }

  /// `Search something`
  String get Search_something {
    return Intl.message(
      'Search something',
      name: 'Search_something',
      desc: '',
      args: [],
    );
  }

  /// `Right to Left`
  String get RTL {
    return Intl.message(
      'Right to Left',
      name: 'RTL',
      desc: '',
      args: [],
    );
  }

  /// `Set text direction to Right to left`
  String get Right_to_left_direction {
    return Intl.message(
      'Set text direction to Right to left',
      name: 'Right_to_left_direction',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Artists`
  String get Artists {
    return Intl.message(
      'Artists',
      name: 'Artists',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get Dark_Theme {
    return Intl.message(
      'Dark Theme',
      name: 'Dark_Theme',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic Theme`
  String get Dynamic_Theme {
    return Intl.message(
      'Dynamic Theme',
      name: 'Dynamic_Theme',
      desc: '',
      args: [],
    );
  }

  /// `Play All`
  String get Play_All {
    return Intl.message(
      'Play All',
      name: 'Play_All',
      desc: '',
      args: [],
    );
  }

  /// `Tracks`
  String get Tracks {
    return Intl.message(
      'Tracks',
      name: 'Tracks',
      desc: '',
      args: [],
    );
  }

  /// `Audio Quality`
  String get Audio_Quality {
    return Intl.message(
      'Audio Quality',
      name: 'Audio_Quality',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get High {
    return Intl.message(
      'High',
      name: 'High',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get Medium {
    return Intl.message(
      'Medium',
      name: 'Medium',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get Low {
    return Intl.message(
      'Low',
      name: 'Low',
      desc: '',
      args: [],
    );
  }

  /// `Experimental`
  String get Experimental {
    return Intl.message(
      'Experimental',
      name: 'Experimental',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get About {
    return Intl.message(
      'About',
      name: 'About',
      desc: '',
      args: [],
    );
  }

  /// `SOCIALS`
  String get SOCIALS {
    return Intl.message(
      'SOCIALS',
      name: 'SOCIALS',
      desc: '',
      args: [],
    );
  }

  /// `TROUBLESHOOTING`
  String get TROUBLESHOOTING {
    return Intl.message(
      'TROUBLESHOOTING',
      name: 'TROUBLESHOOTING',
      desc: '',
      args: [],
    );
  }

  /// `Open in Browser`
  String get Open_in_Browser {
    return Intl.message(
      'Open in Browser',
      name: 'Open_in_Browser',
      desc: '',
      args: [],
    );
  }

  /// `View source Code`
  String get View_source_code {
    return Intl.message(
      'View source Code',
      name: 'View_source_code',
      desc: '',
      args: [],
    );
  }

  /// `Report an issue`
  String get Report_an_issue {
    return Intl.message(
      'Report an issue',
      name: 'Report_an_issue',
      desc: '',
      args: [],
    );
  }

  /// `You will be redirected to Github`
  String get github_redirect {
    return Intl.message(
      'You will be redirected to Github',
      name: 'github_redirect',
      desc: '',
      args: [],
    );
  }

  /// `Request a feature`
  String get Request_a_feature {
    return Intl.message(
      'Request a feature',
      name: 'Request_a_feature',
      desc: '',
      args: [],
    );
  }

  /// `Change Country`
  String get Change_country {
    return Intl.message(
      'Change Country',
      name: 'Change_country',
      desc: '',
      args: [],
    );
  }

  /// `My Favorites`
  String get My_Favorites {
    return Intl.message(
      'My Favorites',
      name: 'My_Favorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Queue`
  String get Remove_from_Queue {
    return Intl.message(
      'Remove from Queue',
      name: 'Remove_from_Queue',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Favorites`
  String get Remove_from_favorites {
    return Intl.message(
      'Remove from Favorites',
      name: 'Remove_from_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Add to Favorites`
  String get Add_to_favorites {
    return Intl.message(
      'Add to Favorites',
      name: 'Add_to_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get Theme {
    return Intl.message(
      'Theme',
      name: 'Theme',
      desc: '',
      args: [],
    );
  }

  /// `Nothing Here`
  String get Nothing_Here {
    return Intl.message(
      'Nothing Here',
      name: 'Nothing_Here',
      desc: '',
      args: [],
    );
  }

  /// `Albums`
  String get Albums {
    return Intl.message(
      'Albums',
      name: 'Albums',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get CANCEL {
    return Intl.message(
      'CANCEL',
      name: 'CANCEL',
      desc: '',
      args: [],
    );
  }

  /// `REMOVE`
  String get REMOVE {
    return Intl.message(
      'REMOVE',
      name: 'REMOVE',
      desc: '',
      args: [],
    );
  }

  /// `Remove from search history?`
  String get Remove_from_search_history {
    return Intl.message(
      'Remove from search history?',
      name: 'Remove_from_search_history',
      desc: '',
      args: [],
    );
  }

  /// `Play next`
  String get Play_next {
    return Intl.message(
      'Play next',
      name: 'Play_next',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get Videos {
    return Intl.message(
      'Videos',
      name: 'Videos',
      desc: '',
      args: [],
    );
  }

  /// `Theme Mode`
  String get Theme_Mode {
    return Intl.message(
      'Theme Mode',
      name: 'Theme_Mode',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get System {
    return Intl.message(
      'System',
      name: 'System',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get Light {
    return Intl.message(
      'Light',
      name: 'Light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get Dark {
    return Intl.message(
      'Dark',
      name: 'Dark',
      desc: '',
      args: [],
    );
  }

  /// `Pitch black`
  String get Pitch_black {
    return Intl.message(
      'Pitch black',
      name: 'Pitch_black',
      desc: '',
      args: [],
    );
  }

  /// `Material You colors`
  String get Material_You_colors {
    return Intl.message(
      'Material You colors',
      name: 'Material_You_colors',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get History {
    return Intl.message(
      'History',
      name: 'History',
      desc: '',
      args: [],
    );
  }

  /// `Recently played`
  String get Recently_played {
    return Intl.message(
      'Recently played',
      name: 'Recently_played',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get Recommended {
    return Intl.message(
      'Recommended',
      name: 'Recommended',
      desc: '',
      args: [],
    );
  }

  /// `Clear search history`
  String get Clear_search_history {
    return Intl.message(
      'Clear search history',
      name: 'Clear_search_history',
      desc: '',
      args: [],
    );
  }

  /// `Clear song history`
  String get Clear_song_history {
    return Intl.message(
      'Clear song history',
      name: 'Clear_song_history',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete search history`
  String get Are_you_sure_to_delete_search_history {
    return Intl.message(
      'Are you sure to delete search history',
      name: 'Are_you_sure_to_delete_search_history',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete song history`
  String get Are_you_sure_to_delete_song_history {
    return Intl.message(
      'Are you sure to delete song history',
      name: 'Are_you_sure_to_delete_song_history',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get YES {
    return Intl.message(
      'YES',
      name: 'YES',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get NO {
    return Intl.message(
      'NO',
      name: 'NO',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get Update {
    return Intl.message(
      'Update',
      name: 'Update',
      desc: '',
      args: [],
    );
  }

  /// `OKAY`
  String get OKAY {
    return Intl.message(
      'OKAY',
      name: 'OKAY',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get DOWNLOAD {
    return Intl.message(
      'Download',
      name: 'DOWNLOAD',
      desc: '',
      args: [],
    );
  }

  /// `New Update Available`
  String get New_Update_Available {
    return Intl.message(
      'New Update Available',
      name: 'New_Update_Available',
      desc: '',
      args: [],
    );
  }

  /// `Vibe Music is already up to date.`
  String get Already_updated {
    return Intl.message(
      'Vibe Music is already up to date.',
      name: 'Already_updated',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'or'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}