import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeApi {
  static String hostAddress = "https://vibeapi-sheikh-haziq.vercel.app/";

  static setCountry() async {
    final response = await get(Uri.parse('http://ip-api.com/json'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes));
      String country = data['countryCode'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('country', country);
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
    String country = prefs.getString('country') ?? "IN";
    final response = await get(
        Uri.parse('${hostAddress}charts?lang=$lang&country=$country'));
    if (response.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(response.bodyBytes))['videos'] ??
          jsonDecode(utf8.decode(response.bodyBytes))['trending'];
      return data;
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
