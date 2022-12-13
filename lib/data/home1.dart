import 'dart:convert';

import 'package:http/http.dart';

class HomeApi {
  static String hostAddress = "https://vibeapi-sheikh-haziq.vercel.app/";
  static Future<List> getHome() async {
    final response = await get(Uri.parse('${hostAddress}home'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data;
    }
    return [];
  }

  static Future<Map> getSearch(query) async {
    final response = await get(Uri.parse('$hostAddress/search?query=$query'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data;
    }
    return {};
  }

  static Future<Map> getPlaylist(id) async {
    final response = await get(Uri.parse('$hostAddress/playlist?id=$id'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data;
    }
    return {};
  }

  static Future<List> getWatchPlaylist(String videoId, int limit) async {
    String url =
        "$hostAddress/searchwatchplaylist?videoId=$videoId&limit=$limit";
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List tracks = data['tracks'];

      return tracks;
    }
    return [];
  }

  static Future<List> getSongs(query) async {
    final response = await get(Uri.parse('$hostAddress/songs?query=$query'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data;
    }
    return [];
  }

  static Future<List> getArtists(query) async {
    final response = await get(Uri.parse('$hostAddress/artists?query=$query'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data;
    }
    return [];
  }
}
