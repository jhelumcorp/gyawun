import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

class Lyrics {
  Map lyricsList = {};
  Future<Map<String, dynamic>> getLyrics({
    required String videoId,
    required String title,
    required int durationInSeconds,
    String? artist,
    String? album,
  }) async {
    if (lyricsList[videoId] != null) {
      return lyricsList[videoId];
    }
    Map response = await fetchLyrics(
        videoId: videoId,
        title: title,
        durationInSeconds: durationInSeconds,
        album: album,
        artist: artist);
    if (response["syncedLyrics"] != null || response['plainLyrics'] != null) {
      final lyricsData = {
        "syncedLyrics": response["syncedLyrics"],
        "plainLyrics": response["plainLyrics"]
      };
      lyricsList[videoId] = lyricsData;
      return lyricsData;
    }
    return {'success': false};
  }

  Future<Map> fetchLyrics({
    required String videoId,
    required String title,
    required int durationInSeconds,
    String? artist,
    String? album,
  }) async {
    String url =
        'http://lrclib.net/api/search?track_name=${title.replaceAll(' ', '+')}';
    Map lyric;
    if (artist != null && album != null) {
      url =
          'http://lrclib.net/api/get?artist_name=${artist.replaceAll(' ', '+')}&track_name=${title.replaceAll(' ', '+')}&album_name=${album.replaceAll(' ', '+')}&duration=$durationInSeconds';
      Uri uri = Uri.parse(url);
      Uint8List bodyBytes = (await get(uri)).bodyBytes;
      Map decoded = jsonDecode(utf8.decode(bodyBytes));
      lyric = decoded;
    } else {
      if (artist != null) {
        url += '&artist_name=${artist.replaceAll(' ', '+')}';
      }
      if (album != null) {
        url += '&album_name=${album.replaceAll(' ', '+')}';
      }
      Uri uri = Uri.parse(url);
      Uint8List bodyBytes = (await get(uri)).bodyBytes;
      List decoded = jsonDecode(utf8.decode(bodyBytes));
      decoded.sort((a, b) {
        double dif1 =
            ((a['duration'] as double) - durationInSeconds.toDouble()).abs();
        double dif2 =
            ((b['duration'] as double) - durationInSeconds.toDouble()).abs();
        return dif1.compareTo(dif2);
      });
      lyric = decoded.isNotEmpty ? decoded.first : {};
    }
    return lyric;
  }
}
