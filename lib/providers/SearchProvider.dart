import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:vibe_music/data/YTMusic/ytmusic.dart';
import 'package:vibe_music/data/home1.dart';

class SearchProvider extends ChangeNotifier {
  List _songs = [];
  List _videos = [];
  List _artists = [];
  List _albums = [];
  List _playlists = [];

  bool _songsLoaded = false;
  bool _videosLoaded = false;
  bool _artistsLoaded = false;
  bool _albumsLoaded = false;
  bool _playlistsLoaded = false;

  bool get songsLoaded => _songsLoaded;
  bool get videosLoaded => _videosLoaded;
  bool get artistsLoaded => _artistsLoaded;
  bool get albumsLoaded => _albumsLoaded;
  bool get playlistsLoaded => _playlistsLoaded;

  List get songs => _songs;
  List get videos => _videos;
  List get artists => _artists;
  List get albums => _albums;
  List get playlists => _playlists;

  refresh() {
    _songsLoaded = false;
    _videosLoaded = false;
    _artistsLoaded = false;
    _albumsLoaded = false;
    _playlistsLoaded = false;
    notifyListeners();
  }

  searchSongs(query) async {
    if (!_songsLoaded) {
      //  HomeApi.searchSongs(query)
      YTMUSIC.search(query, filter: 'songs').then((value) {
        List songs = jsonDecode(jsonEncode(value));

        _songs = songs;
        _songsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchVideos(query) async {
    if (!_videosLoaded) {
      YTMUSIC.search(query, filter: 'videos').then((value) {
        _videos = jsonDecode(jsonEncode(value));
        _videosLoaded = true;
        notifyListeners();
      });
    }
  }

  searchArtists(query) async {
    if (!_artistsLoaded) {
      YTMUSIC.search(query, filter: 'artists').then((value) {
        _artists = jsonDecode(jsonEncode(value));
        _artistsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchAlbums(query) async {
    if (!_albumsLoaded) {
      YTMUSIC.search(query, filter: 'albums').then((value) {
        _albums = jsonDecode(jsonEncode(value));
        _albumsLoaded = true;
        notifyListeners();
      });
    }
  }

  searchPlaylists(query) async {
    if (!_playlistsLoaded) {
      YTMUSIC.search(query, filter: 'playlists').then((value) {
        _playlists = jsonDecode(jsonEncode(value));
        _playlistsLoaded = true;
        notifyListeners();
      });
    }
  }
}
