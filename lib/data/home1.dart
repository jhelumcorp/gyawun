import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeApi {
  static String hostAddress = "https://vibeapi-sheikh-haziq.vercel.app/";

  static setCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countryCode = prefs.getString('countryCode');
    if (countryCode == null) {
      try {
        final response = await get(Uri.parse('http://ip-api.com/json'));
        if (response.statusCode == 200) {
          Map data = jsonDecode(utf8.decode(response.bodyBytes));
          String countryCode = data['countryCode'];
          await prefs.setString('countryCode', countryCode);
        } else {
          await prefs.setString('countryCode', 'IN');
        }
      } catch (err) {
        await prefs.setString('countryCode', 'IN');
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
    final Uri link = Uri.https(
      searchAuthority,
      paths['music'].toString(),
    );
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

      final List finalResult = shelfRenderer.map((element) {
        if (element['title']['runs'][0]['text'].trim() !=
            'Highlights from Global Citizen Live') {
          return {
            'title': element['title']['runs'][0]['text'],
            'playlists': element['title']['runs'][0]['text'].trim() ==
                        'Charts' ||
                    element['title']['runs'][0]['text'].trim() == 'Classements'
                ? formatChartItems(
                    element['content']['horizontalListRenderer']['items']
                        as List,
                  )
                : element['title']['runs'][0]['text']
                            .toString()
                            .contains('Music Videos') ||
                        element['title']['runs'][0]['text']
                            .toString()
                            .contains('Nouveaux clips') ||
                        element['title']['runs'][0]['text']
                            .toString()
                            .contains('En Musique Avec Moi') ||
                        element['title']['runs'][0]['text']
                            .toString()
                            .contains('Performances Uniques')
                    ? formatVideoItems(
                        element['content']['horizontalListRenderer']['items']
                            as List,
                      )
                    : formatItems(
                        element['content']['horizontalListRenderer']['items']
                            as List,
                      ),
          };
        } else {
          return null;
        }
      }).toList();

      final List finalHeadResult = formatHeadItems(headResult);
      finalResult.removeWhere((element) => element == null);

      return {'body': finalResult, 'head': finalHeadResult};
    } catch (e) {
      log('Error in getMusicHome: $e');
      return {};
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    final response = await get(Uri.parse('${hostAddress}home?lang=$lang'));
    if (response.statusCode == 200) {
      List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return [];
  }

  static Future<Map> getCharts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    String country = prefs.getString('countryCode') ?? "IN";

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    final Response response =
        await get(Uri.parse('$hostAddress/search?query=$query&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<Map> getArtist(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    final response =
        await get(Uri.parse('$hostAddress/artist?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<Map> getPlaylist(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    final response =
        await get(Uri.parse('$hostAddress/playlist?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<Map> getAlbum(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
    final response =
        await get(Uri.parse('$hostAddress/album?id=$id&lang=$lang'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    }
    return {};
  }

  static Future<List> getWatchPlaylist(String videoId, int limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('locale') ?? "en";
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
