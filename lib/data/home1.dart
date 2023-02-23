import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../Models/HomeModel.dart';

Box box = Hive.box('settings');

class HomeApi {
  static String hostAddress = "https://vibeapi-sheikh-haziq.vercel.app/";

  static setCountry() async {
    String? countryCode = box.get('countryCode');
    if (countryCode == null) {
      try {
        final response = await get(Uri.parse('http://ip-api.com/json'));
        if (response.statusCode == 200) {
          Map data = jsonDecode(utf8.decode(response.bodyBytes));
          String countryCode = data['countryCode'];
          String countryName = data['country'];
          await box.put('countryCode', countryCode);
          await box.put('countryName', countryName);
        }
      } catch (err) {
        await box.put('countryCode', 'IN');
        await box.put('countryName', 'India');
      }
    }
  }

  static const String searchAuthority = 'www.youtube.com';
  static const Map paths = {
    'search': '/results',
    'channel': '/channel',
    'music': '/music',
    'playlist': '/playlist'
  };
  static const Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
  };
  Future<List> getSearchSuggestions({required String query}) async {
    const baseUrl =
        'https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=';
    final Uri link = Uri.parse(baseUrl + query);
    try {
      final Response response = await get(link, headers: headers);
      if (response.statusCode != 200) {
        return [];
      }
      final List res = jsonDecode(response.body)[1] as List;
      return res;
    } catch (e) {
      log('Error in getSearchSuggestions: $e');
      return [];
    }
  }

  Future<Map<String, List>> getMusicHome() async {
    final Uri link = Uri.https(searchAuthority, paths['music'].toString(), {
      'hl': box.get('language_code', defaultValue: 'en'),
      'gl': box.get('countryCode', defaultValue: 'IN')
    });
    try {
      final Response response = await get(link);
      if (response.statusCode != 200) {
        return {};
      }
      final String searchResults =
          RegExp(r'(\"contents\":{.*?}),\"metadata\"', dotAll: true)
              .firstMatch(response.body)![1]!;
      final Map data = json.decode('{$searchResults}') as Map;

      final List result = data['contents']['twoColumnBrowseResultsRenderer']
              ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
          ['contents'] as List;

      final List headResult = data['header']['carouselHeaderRenderer']
          ['contents'][0]['carouselItemRenderer']['carouselItems'] as List;

      final List shelfRenderer = result.map((element) {
        return element['itemSectionRenderer']['contents'][0]['shelfRenderer'];
      }).toList();

      var finalResult = _finalResult(shelfRenderer);

      final List finalHeadResult = formatHeadItems(headResult);
      finalResult.removeWhere((element) => element.playlists.isEmpty);

      return {'body': finalResult, 'head': finalHeadResult};
    } catch (e) {
      log('Error in getMusicHome: $e');
      return {};
    }
  }

  /*
   * Gets the final list of playlists sorted by the name of each iterated item,
   * this list contains the url of the video and playlists of each horizontal 
   * column reflected in Youtube.
   */
  List<HomeModel> _finalResult(List shelfRenderer) {
    var data = <HomeModel>[];

    try {
      for (var element in shelfRenderer) {
        HomeModel homeModel = HomeModel(title: "", playlists: []);

        if (element['title']['runs'][0]['text'].trim() !=
            'Highlights from Global Citizen Live') {
          homeModel.title = element['title']['runs'][0]['text'].toString();

          if (element['content']['horizontalListRenderer']['items'][0]
                      ['gridPlaylistRenderer'] !=
                  null &&
              element['content']['horizontalListRenderer']['items'][0]
                          ['gridPlaylistRenderer']['shortBylineText']['runs'][0]
                      ['text']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains('chart')) {
            //Lists YouTube Music Global Charts.
            homeModel.playlists = formatChartItems(
                element['content']['horizontalListRenderer']['items']);
            data.add(homeModel);
          }

          if (element['content']['horizontalListRenderer']['items'][0]
                  ['gridVideoRenderer'] !=
              null) {
            //The video playlist is added.
            homeModel.playlists = formatVideoItems(
                element['content']['horizontalListRenderer']['items']);
            data.add(homeModel);
          }

          if (element['content']['horizontalListRenderer']['items'][0]
                  ['compactStationRenderer'] !=
              null) {
            //Lists other than videos or video playlists are added.
            homeModel.playlists = formatItems(
                element['content']['horizontalListRenderer']['items']);
            data.add(homeModel);
          }
        }
      }
      return data;
    } catch (e) {
      return <HomeModel>[];
    }
  }

  List formatChartItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridPlaylistRenderer']['title']['runs'][0]['text'],
          'type': 'chart',
          'description': e['gridPlaylistRenderer']['shortBylineText']['runs'][0]
              ['text'],
          'count': e['gridPlaylistRenderer']['videoCountText']['runs'][0]
              ['text'],
          'playlistId': e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          'firstItemId': e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageStandard': e['gridPlaylistRenderer']['thumbnail']['thumbnails']
              [0]['url'],
          'imageMax': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      log('Error in formatChartItems: $e');
      return List.empty();
    }
  }

  List formatVideoItems(List itemsList) {
    if (itemsList.isEmpty) {
      return List.empty();
    }
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridVideoRenderer']['title']['simpleText'],
          'type': 'video',
          'description': e['gridVideoRenderer']['shortBylineText']['runs'][0]
              ['text'],
          'count': e['gridVideoRenderer']['shortViewCountText']['simpleText'],
          'videoId': e['gridVideoRenderer']['videoId'],
          'firstItemId': e['gridVideoRenderer']['videoId'],
          'image':
              e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
          'imageMin': e['gridVideoRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['gridVideoRenderer']['thumbnail']['thumbnails'][1]
              ['url'],
          'imageStandard': e['gridVideoRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
          'imageMax':
              e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      log('Error in formatVideoItems: $e');
      return List.empty();
    }
  }

  List formatItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['compactStationRenderer']['title']['simpleText'],
          'type': 'playlist',
          'description': e['compactStationRenderer']['description']
              ['simpleText'],
          'count': e['compactStationRenderer']['videoCountText']['runs'][0]
              ['text'],
          'playlistId': e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          'firstItemId': e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['compactStationRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['compactStationRenderer']['thumbnail']['thumbnails']
              [0]['url'],
          'imageStandard': e['compactStationRenderer']['thumbnail']
              ['thumbnails'][1]['url'],
          'imageMax': e['compactStationRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      log('Error in formatItems: $e');
      return List.empty();
    }
  }

  List formatHeadItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['defaultPromoPanelRenderer']['title']['runs'][0]['text'],
          'type': 'video',
          'description':
              (e['defaultPromoPanelRenderer']['description']['runs'] as List)
                  .map((e) => e['text'])
                  .toList()
                  .join(),
          'videoId': e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'firstItemId': e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
          'imageMedium': e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][1]['url'],
          'imageStandard': e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][2]['url'],
          'imageMax': e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      log('Error in formatHeadItems: $e');
      return List.empty();
    }
  }

  static Future<List> getHome() async {
    String lang = box.get('language_code', defaultValue: 'en');
    final response = await get(Uri.parse('${hostAddress}home?lang=$lang'));
    if (response.statusCode == 200) {
      List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return [];
  }

  static Future<Map> getCharts() async {
    String lang = box.get('language_code', defaultValue: 'en');
    String country = box.get('countryCode', defaultValue: 'IN');

    final response = await get(
        Uri.parse('${hostAddress}charts?lang=$lang&country=$country'));
    if (response.statusCode == 200) {
      List trending = jsonDecode(utf8.decode(response.bodyBytes))['videos']
              ['items'] ??
          jsonDecode(utf8.decode(response.bodyBytes))['trending']['items'];
      List artists =
          jsonDecode(utf8.decode(response.bodyBytes))['artists']['items'];
      return {
        'trending': trending,
        'artists': artists,
      };
    }
    return {};
  }

  static Future<Map> getSearch(query) async {
    String lang = box.get('language_code', defaultValue: 'en');
    final Response response =
        await get(Uri.parse('$hostAddress/search?query=$query&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<List> searchSongs(query) async {
    return await searchCategory(query, 'song');
  }

  static Future<List> searchVideos(query) async {
    return await searchCategory(query, 'video');
  }

  static Future<List> searchArtists(query) async {
    return await searchCategory(query, 'artist');
  }

  static Future<List> searchAlbums(query) async {
    return await searchCategory(query, 'album');
  }

  static Future<List> searchPlaylists(query) async {
    return await searchCategory(query, 'playlist');
  }

  static Future<List> searchCategory(query, category) async {
    String lang = box.get('language_code', defaultValue: 'en');
    final Response response = await get(
        Uri.parse('$hostAddress/search/$category?query=$query&lang=$lang'));
    if (response.statusCode == 200) {
      List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return [];
  }

  static Future<Map> getArtist(id) async {
    String lang = box.get('language_code', defaultValue: 'en');
    final response =
        await get(Uri.parse('$hostAddress/artist?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<Map> getPlaylist(id) async {
    String lang = box.get('language_code', defaultValue: 'en');

    final response =
        await get(Uri.parse('$hostAddress/playlist?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<Map> getAlbum(id) async {
    String lang = box.get('language_code', defaultValue: 'en');

    final response =
        await get(Uri.parse('$hostAddress/album?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<List> getWatchPlaylist(String videoId, int limit) async {
    String lang = box.get('language_code', defaultValue: 'en');

    String url =
        "$hostAddress/searchwatchplaylist?videoId=$videoId&limit=$limit&lang=$lang";
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      List tracks = data['tracks'];

      return tracks;
    }
    return [];
  }
}
