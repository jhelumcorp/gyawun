import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchProvider extends ChangeNotifier {
  String _query = "";
  List _songs = [];
  List _artists = [];
  List _albums = [];
  List _playlists = [];

  bool _songsLoaded = false;
  bool _artistsLoaded = false;
  bool _albumsLoaded = false;
  bool _playlistsLoaded = false;

  bool get songsLoaded => _songsLoaded;
  bool get artistsLoaded => _artistsLoaded;
  bool get albumsLoaded => _albumsLoaded;
  bool get playlistsLoaded => _playlistsLoaded;

  List get songs => _songs;
  List get artists => _artists;
  List get albums => _albums;
  List get playlists => _playlists;

  refresh() {
    _songsLoaded = false;
    _artistsLoaded = false;
    _albumsLoaded = false;
    _playlistsLoaded = false;
    notifyListeners();
  }

  searchSongs(query) async {
    if (!_songsLoaded) {
      HomeApi.searchSongs(query).then((value) {
        _songs = value;
        _songsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchArtists(query) async {
    if (!_artistsLoaded) {
      HomeApi.searchArtists(query).then((value) {
        _artists = value;
        _artistsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchAlbums(query) async {
    if (!_albumsLoaded) {
      HomeApi.searchAlbums(query).then((value) {
        _albums = value;
        _albumsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchPlaylists(query) async {
    if (!_playlistsLoaded) {
      HomeApi.searchPlaylists(query).then((value) {
        _playlists = value;
        _playlistsLoaded = true;
        notifyListeners();
      });
    }
  }
}
