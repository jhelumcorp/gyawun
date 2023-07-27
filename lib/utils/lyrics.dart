import 'dart:convert';

import 'package:gyawun/utils/spotify.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

class Lyrics {
  String? accessToken;

  Future<Map<String, String>> getLyrics({
    required String id,
    required String title,
    required String artist,
    required bool saavnHas,
  }) async {
    final Map<String, String> result = {
      'lyrics': '',
      'type': 'text',
      'source': '',
      'id': id,
    };

    Logger.root.info('Getting Synced Lyrics');
    final res = await getSpotifyLyrics(title, artist);
    result['lyrics'] = res['lyrics'] ?? '';
    result['type'] = res['type'] ?? '';
    result['source'] = res['source'] ?? '';

    if (result['lyrics'] == '') {
      Logger.root.info('Synced Lyrics, not found. Getting text lyrics');
      if (saavnHas) {
        Logger.root.info('Getting Lyrics from Saavn');
        result['lyrics'] = await getSaavnLyrics(id);
        result['type'] = 'text';
        result['source'] = 'Jiosaavn';
        if (result['lyrics'] == '') {
          final res = await getLyrics(
            id: id,
            title: title,
            artist: artist,
            saavnHas: false,
          );
          result['lyrics'] = res['lyrics']!;
          result['type'] = res['type']!;
          result['source'] = res['source']!;
        }
      } else {
        Logger.root
            .info('Lyrics not available on Saavn, finding on Musixmatch');
        result['lyrics'] =
            await getMusixMatchLyrics(title: title, artist: artist);
        result['type'] = 'text';
        result['source'] = 'Musixmatch';
        if (result['lyrics'] == '') {
          Logger.root
              .info('Lyrics not found on Musixmatch, searching on Google');
          result['lyrics'] =
              await getGoogleLyrics(title: title, artist: artist);
          result['type'] = 'text';
          result['source'] = 'Google';
        }
      }
    }
    return result;
  }

  Future<String> getSaavnLyrics(String id) async {
    try {
      final Uri lyricsUrl = Uri.https(
        'www.jiosaavn.com',
        '/api.php?__call=lyrics.getLyrics&lyrics_id=$id&ctx=web6dot0&api_version=4&_format=json',
      );
      final Response res =
          await get(lyricsUrl, headers: {'Accept': 'application/json'});

      final List<String> rawLyrics = res.body.split('-->');
      Map fetchedLyrics = {};
      if (rawLyrics.length > 1) {
        fetchedLyrics = json.decode(rawLyrics[1]) as Map;
      } else {
        fetchedLyrics = json.decode(rawLyrics[0]) as Map;
      }
      final String lyrics =
          fetchedLyrics['lyrics'].toString().replaceAll('<br>', '\n');
      return lyrics;
    } catch (e) {
      Logger.root.severe('Error in getSaavnLyrics', e);
      return '';
    }
  }

  Future<Map<String, String>> getSpotifyLyrics(
    String title,
    String artist,
  ) async {
    Map<String, String> result = {
      'lyrics': '',
      'type': 'text',
      'source': 'Spotify',
    };

    try {
      accessToken ??= await getAccessToken();
      final value = await SpotifyApi().searchTrack(
        accessToken: accessToken!,
        query: '$title - $artist',
        limit: 1,
      );
      Map<String, String> res = await getSpotifyLyricsFromId(
          value['tracks']['items'][0]['id'].toString());
      result = res;
    } catch (err) {
      // print(err.toString());
    }
    return result;
  }

  Future<String?> getAccessToken() async {
    RegExp re = RegExp(
        r'<script id="session" data-testid="session" type="application\/json"\>({.*})<\/script>');
    try {
      final response = await get(Uri.parse("https://open.spotify.com/search"));
      final str = response.body;
      final match = re.firstMatch(str);
      final jsonStr = match?.group(1);
      final json = jsonDecode(jsonStr!);
      return json['accessToken'];
    } catch (err) {
      return null;
    }
  }

  Future<Map<String, String>> getSpotifyLyricsFromId(
    String trackId,
  ) async {
    final Map<String, String> result = {
      'lyrics': '',
      'type': 'text',
      'source': 'Spotify',
    };
    try {
      final Uri lyricsUrl = Uri.https('spotify-lyric-api.herokuapp.com', '/', {
        'trackid': trackId,
        'format': 'lrc',
      });

      final Response res =
          await get(lyricsUrl, headers: {'Accept': 'application/json'});

      if (res.statusCode == 200) {
        final Map lyricsData = await json.decode(res.body) as Map;

        if (lyricsData['error'] == false) {
          final List lines = await lyricsData['lines'] as List;
          if (lyricsData['syncType'] == 'LINE_SYNCED') {
            result['lyrics'] = lines
                .map((e) => '[${e["timeTag"]}]${e["words"]}')
                .toList()
                .join('\n');
            result['type'] = 'lrc';
          } else {
            result['lyrics'] = lines.map((e) => e['words']).toList().join('\n');
            result['type'] = 'text';
          }
        }
      } else {
        Logger.root.severe(
          'getSpotifyLyricsFromId returned ${res.statusCode}',
          res.body,
        );
      }

      return result;
    } catch (e) {
      Logger.root.severe('Error in getSpotifyLyrics', e);
      return result;
    }
  }

  Future<String> getGoogleLyrics({
    required String title,
    required String artist,
  }) async {
    const String url =
        'https://www.google.com/search?client=safari&rls=en&ie=UTF-8&oe=UTF-8&q=';
    const String delimiter1 =
        '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
    const String delimiter2 =
        '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';
    String lyrics = '';
    try {
      lyrics = (await get(
        Uri.parse(Uri.encodeFull('$url$title by $artist lyrics')),
      ))
          .body;
      lyrics = lyrics.split(delimiter1).last;
      lyrics = lyrics.split(delimiter2).first;
      if (lyrics.contains('<meta charset="UTF-8">')) throw Error();
    } catch (_) {
      try {
        lyrics = (await get(
          Uri.parse(
            Uri.encodeFull('$url$title by $artist song lyrics'),
          ),
        ))
            .body;
        lyrics = lyrics.split(delimiter1).last;
        lyrics = lyrics.split(delimiter2).first;
        if (lyrics.contains('<meta charset="UTF-8">')) throw Error();
      } catch (_) {
        try {
          lyrics = (await get(
            Uri.parse(
              Uri.encodeFull(
                '$url${title.split("-").first} by $artist lyrics',
              ),
            ),
          ))
              .body;
          lyrics = lyrics.split(delimiter1).last;
          lyrics = lyrics.split(delimiter2).first;
          if (lyrics.contains('<meta charset="UTF-8">')) throw Error();
        } catch (_) {
          lyrics = '';
        }
      }
    }
    return lyrics.trim();
  }

  // static Future<String> getOffLyrics(String path) async {
  //   try {
  //     final Audiotagger tagger = Audiotagger();
  //     final Tag? tags = await tagger.readTags(path: path);
  //     return tags?.lyrics ?? '';
  //   } catch (e) {
  //     return '';
  //   }
  // }

  Future<String> getLyricsLink(String song, String artist) async {
    const String authority = 'www.musixmatch.com';
    final String unencodedPath = '/search/$song $artist';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) return '';

    final RegExpMatch? result =
        RegExp(r'href=\"(\/lyrics\/.*?)\"').firstMatch(res.body);

    return result == null ? '' : result[1]!;
  }

  Future<String> scrapLink(String unencodedPath) async {
    Logger.root.info('Trying to scrap lyrics from $unencodedPath');
    const String authority = 'www.musixmatch.com';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) return '';
    final List<String?> lyrics = RegExp(
      r'<span class=\"lyrics__content__ok\">(.*?)<\/span>',
      dotAll: true,
    ).allMatches(res.body).map((m) => m[1]).toList();

    return lyrics.isEmpty ? '' : lyrics.join('\n');
  }

  Future<String> getMusixMatchLyrics({
    required String title,
    required String artist,
  }) async {
    try {
      final String link = await getLyricsLink(title, artist);
      Logger.root.info('Found Musixmatch Lyrics Link: $link');
      final String lyrics = await scrapLink(link);
      return lyrics;
    } catch (e) {
      Logger.root.severe('Error in getMusixMatchLyrics', e);
      return '';
    }
  }
}

bool matchSongs({
  required String title,
  required String artist,
  required String title2,
  required String artist2,
  double artistFlexibility = 0.15,
  double titleFlexibility = 0.7,
  bool allowTitleToArtistMatch = true,
}) {
  Logger.root.info('Matching $title by $artist with $title2 by $artist2');
  final names1 = artist.replaceAll('&', ',').replaceAll('-', ',').split(',');
  final names2 = artist2.replaceAll('&', ',').replaceAll('-', ',').split(',');
  bool artistMatched = false;
  bool titleMatched = false;

  // Check if at least one artist name matches
  for (final String name1 in names1) {
    for (final String name2 in names2) {
      if (flexibleMatch(
        string1: name1,
        string2: name2,
        flexibility: artistFlexibility,
      )) {
        artistMatched = true;
        break;
      } else if (allowTitleToArtistMatch) {
        if (title2.contains(name1) || title.contains(name2)) {
          artistMatched = true;
          break;
        }
      }
    }
    if (artistMatched) {
      break;
    }
  }

  titleMatched = flexibleMatch(
    string1: title,
    string2: title2,
    wordMatch: true,
    flexibility: titleFlexibility,
  );

  Logger.root
      .info('TitleMatched: $titleMatched, ArtistMatched: $artistMatched');

  return artistMatched && titleMatched;
}

bool flexibleMatch({
  required String string1,
  required String string2,
  double flexibility = 0.7,
  bool wordMatch = false,
}) {
  final text1 = string1.toLowerCase().trim();
  final text2 = string2.toLowerCase().trim();
  if (text1 == text2) {
    return true;
  } else if (text1.contains(text2) || text2.contains(text1)) {
    return true;
  } else if (flexibility > 0) {
    final bool matched = flexibilityCheck(
      text1: text1,
      text2: text2,
      wordMatch: wordMatch,
      flexibility: flexibility,
    );
    if (matched) {
      return true;
    } else if (text1.contains('(') || text2.contains('(')) {
      return flexibilityCheck(
        text1: text1.split('(')[0].trim(),
        text2: text2.split('(')[0].trim(),
        wordMatch: wordMatch,
        flexibility: flexibility,
      );
    }
  }

  return false;
}

bool flexibilityCheck({
  required String text1,
  required String text2,
  required bool wordMatch,
  required double flexibility,
}) {
  int count = 0;
  final list1 = wordMatch ? text1.split(' ') : text1.split('');
  final list2 = wordMatch ? text2.split(' ') : text2.split('');
  final minLength = list1.length > list2.length ? list2.length : list1.length;

  for (int i = 0; i < minLength; i++) {
    if (list1[i] == list2[i]) {
      count++;
    } else {
      break;
    }
  }
  final percentage = count / minLength;
  if ((1 - percentage) <= flexibility) {
    return true;
  }
  return false;
}
