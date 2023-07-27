import 'dart:convert';
import 'dart:developer';

import 'package:gyawun/api/format.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

Box box = Hive.box('settings');

class SaavnAPI {
  List<String> preferredLanguages =
      box.get('languages', defaultValue: ["English"]);
  Map<String, String> headers = {};
  String baseUrl = 'www.jiosaavn.com';
  String apiStr = '/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0';
  Map<String, String> endpoints = {
    'homeData': '__call=webapi.getLaunchData',
    'topSearches': '__call=content.getTopSearches',
    'fromToken': '__call=webapi.get',
    'featuredRadio': '__call=webradio.createFeaturedStation',
    'artistRadio': '__call=webradio.createArtistStation',
    'entityRadio': '__call=webradio.createEntityStation',
    'radioSongs': '__call=webradio.getSong',
    'songDetails': '__call=song.getDetails',
    'playlistDetails': '__call=playlist.getDetails',
    'albumDetails': '__call=content.getAlbumDetails',
    'getResults': '__call=search.getResults',
    'albumResults': '__call=search.getAlbumResults',
    'artistResults': '__call=search.getArtistResults',
    'playlistResults': '__call=search.getPlaylistResults',
    'getReco': '__call=reco.getreco',
    'getAlbumReco': '__call=reco.getAlbumReco', // still not used
    'artistOtherTopSongs':
        '__call=search.artistOtherTopSongs', // still not used
  };

  Future<Response> getResponse(
    String params, {
    bool usev4 = true,
    bool useProxy = false,
  }) async {
    Uri url;
    if (!usev4) {
      url = Uri.https(
        baseUrl,
        '$apiStr&$params'.replaceAll('&api_version=4', ''),
      );
    } else {
      url = Uri.https(baseUrl, '$apiStr&$params');
    }

    if (preferredLanguages.isEmpty) {
      preferredLanguages = ['English'];
    }
    preferredLanguages =
        preferredLanguages.map((lang) => lang.toLowerCase()).toList();
    final String languageHeader = 'L=${preferredLanguages.join('%2C')}';
    headers = {'cookie': languageHeader, 'Accept': '*/*'};

    // if (useProxy && settingsBox.get('useProxy', defaultValue: false) as bool) {
    //   final String proxyIP = settingsBox.get('proxyIp').toString();
    //   // final proxyPort = settingsBox.get('proxyPort');
    //   // final HttpClient httpClient = HttpClient();
    //   // httpClient.findProxy = (uri) {
    //   //   return 'PROXY $proxyIP:$proxyPort;';
    //   // };
    //   // httpClient.badCertificateCallback =
    //   //     (X509Certificate cert, String host, int port) => Platform.isAndroid;
    //   // final IOClient myClient = IOClient(httpClient);
    //   // return myClient.get(url, headers: headers);
    //   final proxyHeaders = headers;
    //   proxyHeaders['X-FORWARDED-FOR'] = proxyIP;
    //   return get(url, headers: proxyHeaders).onError((error, stackTrace) {
    //     return Response(
    //       {
    //         'status': 'failure',
    //         'error': error.toString(),
    //       }.toString(),
    //       404,
    //     );
    //   });
    // }
    return get(url, headers: headers).onError((error, stackTrace) {
      return Response(
        {
          'status': 'failure',
          'error': error.toString(),
        }.toString(),
        404,
      );
    });
  }

  Future<Map> fetchHomePageData() async {
    Map result = {};
    try {
      final res = await getResponse(endpoints['homeData']!);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatHomePageData(data);
      }
    } catch (e) {
      Logger.root.severe('Error in fetchHomePageData: $e');
    }
    return result;
  }

  Future<Map> getSongFromToken(
    String token,
    String type, {
    int n = 10,
    int p = 1,
  }) async {
    if (n == -1) {
      final String params =
          "token=$token&type=$type&n=5&p=$p&${endpoints['fromToken']}";
      try {
        final res = await getResponse(params);
        if (res.statusCode == 200) {
          final Map getMain = json.decode(res.body) as Map;
          final String count = getMain['list_count'].toString();
          final String params2 =
              "token=$token&type=$type&n=$count&p=$p&${endpoints['fromToken']}";
          final res2 = await getResponse(params2);
          if (res2.statusCode == 200) {
            final Map getMain2 = json.decode(res2.body) as Map;
            if (type == 'album' || type == 'playlist') return getMain2;
            final List responseList = getMain2['songs'] as List;
            return {
              'songs':
                  await FormatResponse.formatSongsResponse(responseList, type),
              'title': getMain2['title'],
            };
          }
        }
      } catch (e) {
        Logger.root.severe('Error in getSongFromToken with -1: $e');
      }
      return {'songs': List.empty()};
    } else {
      final String params =
          "token=$token&type=$type&n=$n&p=$p&${endpoints['fromToken']}";
      try {
        final res = await getResponse(params);
        if (res.statusCode == 200) {
          final Map getMain = json.decode(res.body) as Map;
          if (getMain['status'] == 'failure') {
            Logger.root.severe('Error in getSongFromToken response: $getMain');
            return {'songs': List.empty()};
          }
          if (type == 'album' || type == 'playlist') {
            return getMain;
          }
          if (type == 'show') {
            final List responseList = getMain['episodes'] as List;
            return {
              'songs':
                  await FormatResponse.formatSongsResponse(responseList, type),
            };
          }
          if (type == 'mix') {
            final List responseList = getMain['list'] as List;
            return {
              'songs':
                  await FormatResponse.formatSongsResponse(responseList, type),
            };
          }
          final List responseList = getMain['songs'] as List;
          return {
            'songs':
                await FormatResponse.formatSongsResponse(responseList, type),
            'title': getMain['title'],
          };
        }
      } catch (e) {
        Logger.root.severe('Error in getSongFromToken: $e');
      }
      return {'songs': List.empty()};
    }
  }

  Future<List> getReco(String pid) async {
    final String params = "${endpoints['getReco']}&pid=$pid";
    final res = await getResponse(params);
    if (res.statusCode == 200 && res.body.isNotEmpty) {
      final List getMain = json.decode(res.body) as List;
      return FormatResponse.formatSongsResponse(getMain, 'song');
    } else {
      Logger.root.severe(
        'Error in getReco returned status: ${res.statusCode}, response: ${res.body}',
      );
    }
    return List.empty();
  }

  Future<String?> createRadio({
    required List<String> names,
    required String stationType,
    String? language,
  }) async {
    String? params;
    if (stationType == 'featured') {
      params =
          "name=${names[0]}&language=$language&${endpoints['featuredRadio']}";
    }
    if (stationType == 'artist') {
      params =
          "name=${names[0]}&query=${names[0]}&language=$language&${endpoints['artistRadio']}";
    }
    if (stationType == 'entity') {
      params =
          'entity_id=${names.map((e) => '"$e"').toList()}&entity_type=queue&${endpoints["entityRadio"]}';
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final Map getMain = json.decode(res.body) as Map;
      return getMain['stationid']?.toString();
    }
    return null;
  }

  Future<List> getRadioSongs({
    required String stationId,
    int count = 20,
    int next = 1,
  }) async {
    if (count > 0) {
      final String params =
          "stationid=$stationId&k=$count&next=$next&${endpoints['radioSongs']}";
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        final List responseList = [];
        for (int i = 0; i < count; i++) {
          log(i.toString());
          dynamic r = getMain[i.toString()]?['song'];
          if (r != null) {
            responseList.add(r);
          }
        }
        return FormatResponse.formatSongsResponse(responseList, 'song');
      }
      return [];
    }
    return [];
  }

  Future<List<String>> getTopSearches() async {
    try {
      final res = await getResponse(endpoints['topSearches']!, useProxy: true);
      if (res.statusCode == 200) {
        final List getMain = json.decode(res.body) as List;
        return getMain.map((element) {
          return element['title'].toString();
        }).toList();
      }
    } catch (e) {
      Logger.root.severe('Error in getTopSearches: $e');
    }
    return List.empty();
  }

  Future<Map> fetchSongSearchResults({
    required String searchQuery,
    int count = 20,
    int page = 1,
  }) async {
    final String params =
        "p=$page&q=$searchQuery&n=$count&${endpoints['getResults']}";

    try {
      final res = await getResponse(params, useProxy: true);
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        final List responseList = getMain['results'] as List;
        return {
          'songs':
              await FormatResponse.formatSongsResponse(responseList, 'song'),
          'error': '',
        };
      } else {
        return {
          'songs': List.empty(),
          'error': res.body,
        };
      }
    } catch (e) {
      Logger.root.severe('Error in fetchSongSearchResults: $e');
      return {
        'songs': List.empty(),
        'error': e,
      };
    }
  }

  Future<List<Map>> fetchSearchResults(String searchQuery) async {
    final Map<String, List> result = {};
    final Map<int, String> position = {};
    List searchedAlbumList = [];
    List searchedPlaylistList = [];
    List searchedArtistList = [];
    List searchedTopQueryList = [];
    // List searchedShowList = [];
    // List searchedEpisodeList = [];

    final String params =
        '__call=autocomplete.get&cc=in&includeMetaTags=1&query=$searchQuery';

    final res = await getResponse(params, usev4: false, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List albumResponseList = getMain['albums']['data'] as List;
      position[getMain['albums']['position'] as int] = 'Albums';

      final List playlistResponseList = getMain['playlists']['data'] as List;
      position[getMain['playlists']['position'] as int] = 'Playlists';

      final List artistResponseList = getMain['artists']['data'] as List;
      position[getMain['artists']['position'] as int] = 'Artists';

      // final List showResponseList = getMain['shows']['data'] as List;
      // position[getMain['shows']['position'] as int] = 'Podcasts';

      // final List episodeResponseList = getMain['episodes']['data'] as List;
      // position[getMain['episodes']['position'] as int] = 'Episodes';

      final List topQuery = getMain['topquery']['data'] as List;

      searchedAlbumList =
          await FormatResponse.formatAlbumResponse(albumResponseList, 'album');
      if (searchedAlbumList.isNotEmpty) {
        result['Albums'] = searchedAlbumList;
      }

      searchedPlaylistList = await FormatResponse.formatAlbumResponse(
        playlistResponseList,
        'playlist',
      );
      if (searchedPlaylistList.isNotEmpty) {
        result['Playlists'] = searchedPlaylistList;
      }

      // searchedShowList =
      //     await FormatResponse().formatAlbumResponse(showResponseList, 'show');
      // if (searchedShowList.isNotEmpty) {
      //   result['Podcasts'] = searchedShowList;
      // }

      // searchedEpisodeList = await FormatResponse()
      //     .formatAlbumResponse(episodeResponseList, 'episode');
      // if (searchedEpisodeList.isNotEmpty) {
      //   result['Episodes'] = searchedEpisodeList;
      // }

      searchedArtistList = await FormatResponse.formatAlbumResponse(
        artistResponseList,
        'artist',
      );
      if (searchedArtistList.isNotEmpty) {
        result['Artists'] = searchedArtistList;
      }

      if (topQuery.isNotEmpty &&
          (topQuery[0]['type'] != 'playlist' ||
              topQuery[0]['type'] == 'artist' ||
              topQuery[0]['type'] == 'album')) {
        position[getMain['topquery']['position'] as int] = 'Top Result';
        position[getMain['songs']['position'] as int] = 'Songs';

        switch (topQuery[0]['type'] as String) {
          case 'artist':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'artist');
            break;
          case 'album':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'album');
            break;
          case 'playlist':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'playlist');
            break;
          default:
            break;
        }
        if (searchedTopQueryList.isNotEmpty) {
          result['Top Result'] = searchedTopQueryList;
        }
      } else {
        if (topQuery.isNotEmpty && topQuery[0]['type'] == 'song') {
          position[getMain['topquery']['position'] as int] = 'Songs';
        } else {
          position[getMain['songs']['position'] as int] = 'Songs';
        }
      }
    }
    return [result, position];
  }

  Future<List<Map>> fetchAlbums({
    required String searchQuery,
    required String type,
    int count = 20,
    int page = 1,
  }) async {
    String? params;
    if (type == 'playlist') {
      params =
          'p=$page&q=$searchQuery&n=$count&${endpoints["playlistResults"]}';
    }
    if (type == 'album') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["albumResults"]}';
    }
    if (type == 'artist') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["artistResults"]}';
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['results'] as List;
      return FormatResponse.formatAlbumResponse(responseList, type);
    }
    return List.empty();
  }

  Future<Map> fetchAlbumSongs(String albumId) async {
    final String params = '${endpoints['albumDetails']}&cc=in&albumid=$albumId';
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final getMain = json.decode(res.body);
        if (getMain['list'] != '') {
          final List responseList = getMain['list'] as List;
          return {
            'songs':
                await FormatResponse.formatSongsResponse(responseList, 'album'),
            'error': '',
          };
        }
      }
      Logger.root.severe('Songs not found in fetchAlbumSongs: ${res.body}');
      return {
        'songs': List.empty(),
        'error': '',
      };
    } catch (e) {
      Logger.root.severe('Error in fetchAlbumSongs: $e');
      return {
        'songs': List.empty(),
        'error': e,
      };
    }
  }

  Future<Map<String, List>> fetchArtistSongs({
    required String artistToken,
    String category = '',
    String sortOrder = '',
  }) async {
    final Map<String, List> data = {};
    final String params =
        '${endpoints["fromToken"]}&type=artist&p=&n_song=50&n_album=50&sub_type=&category=$category&sort_order=$sortOrder&includeMetaTags=0&token=$artistToken';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body) as Map;
      final List topSongsResponseList = getMain['topSongs'] as List;
      final List latestReleaseResponseList = getMain['latest_release'] as List;
      final List topAlbumsResponseList = getMain['topAlbums'] as List;
      final List singlesResponseList = getMain['singles'] as List;
      final List dedicatedResponseList =
          getMain['dedicated_artist_playlist'] as List;
      final List featuredResponseList =
          getMain['featured_artist_playlist'] as List;
      final List similarArtistsResponseList = getMain['similarArtists'] as List;

      final List topSongsSearchedList =
          await FormatResponse.formatSongsResponse(
        topSongsResponseList,
        'song',
      );
      if (topSongsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topSongs']?['title']?.toString() ??
            'Top Songs'] = topSongsSearchedList;
      }

      final List latestReleaseSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        latestReleaseResponseList,
      );
      if (latestReleaseSearchedList.isNotEmpty) {
        data[getMain['modules']?['latest_release']?['title']?.toString() ??
            'Latest Releases'] = latestReleaseSearchedList;
      }

      final List topAlbumsSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        topAlbumsResponseList,
      );
      if (topAlbumsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topAlbums']?['title']?.toString() ??
            'Top Albums'] = topAlbumsSearchedList;
      }

      final List singlesSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        singlesResponseList,
      );
      if (singlesSearchedList.isNotEmpty) {
        data[getMain['modules']?['singles']?['title']?.toString() ??
            'Singles'] = singlesSearchedList;
      }

      final List dedicatedSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        dedicatedResponseList,
      );
      if (dedicatedSearchedList.isNotEmpty) {
        data[getMain['modules']?['dedicated_artist_playlist']?['title']
                ?.toString() ??
            'Dedicated Playlists'] = dedicatedSearchedList;
      }

      final List featuredSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        featuredResponseList,
      );
      if (featuredSearchedList.isNotEmpty) {
        data[getMain['modules']?['featured_artist_playlist']?['title']
                ?.toString() ??
            'Featured Playlists'] = featuredSearchedList;
      }

      final List similarArtistsSearchedList =
          await FormatResponse.formatSimilarArtistsResponse(
        similarArtistsResponseList,
      );
      if (similarArtistsSearchedList.isNotEmpty) {
        data[getMain['modules']?['similarArtists']?['title']?.toString() ??
            'Similar Artists'] = similarArtistsSearchedList;
      }
    }
    return data;
  }

  Future<Map> fetchPlaylistSongs(String playlistId) async {
    final String params =
        '${endpoints["playlistDetails"]}&cc=in&listid=$playlistId';
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final getMain = json.decode(res.body);
        if (getMain['list'] != '') {
          final List responseList = getMain['list'] as List;
          return {
            'songs': await FormatResponse.formatSongsResponse(
              responseList,
              'playlist',
            ),
            'error': '',
          };
        }
        return {
          'songs': List.empty(),
          'error': '',
        };
      } else {
        return {
          'songs': List.empty(),
          'error': res.body,
        };
      }
    } catch (e) {
      Logger.root.severe('Error in fetchPlaylistSongs: $e');
      return {
        'songs': List.empty(),
        'error': e,
      };
    }
  }

  Future<List> fetchTopSearchResult(String searchQuery) async {
    final String params = 'p=1&q=$searchQuery&n=10&${endpoints["getResults"]}';
    final res = await getResponse(params, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['results'] as List;
      return [
        await FormatResponse.formatSingleSongResponse(responseList[0] as Map)
      ];
    }
    return List.empty();
  }

  Future<Map> fetchSongDetails(String songId) async {
    final String params = 'pids=$songId&${endpoints["songDetails"]}';
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        return await FormatResponse.formatSingleSongResponse(
          data['songs'][0] as Map,
        );
      }
    } catch (e) {
      Logger.root.severe('Error in fetchSongDetails: $e');
    }
    return {};
  }
}
