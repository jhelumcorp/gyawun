import 'dart:developer';

import '../YTMService.dart';

class Playlist extends YTMService {
  Future<Map> getPlaylistDetails(String playlistId) async {
    if (headers == null) {
      await init();
    }
    try {
      final browseId =
          playlistId.startsWith('VL') ? playlistId : 'VL$playlistId';
      final body = Map.from(context!);
      body['browseId'] = browseId;
      final Map response =
          await sendRequest(endpoints['browse']!, body, headers);
      final Map finalResults = nav(response, [
            'contents',
            'singleColumnBrowseResultsRenderer',
            'tabs',
            0,
            'tabRenderer',
            'content',
            'sectionListRenderer',
            'contents',
            0,
            'musicPlaylistShelfRenderer'
          ]) as Map? ??
          {};
      Map playlist = {
        'playlistId': finalResults['playlistId'],
      };
      dynamic header = response['header']['musicDetailHeaderRenderer'];
      playlist['privacy'] = 'PUBLIC';
      playlist['title'] = nav(header, ['title', 'runs', 0, 'text']);
      playlist['thumbnails'] = nav(header, [
        'thumbnail',
        'croppedSquareThumbnailRenderer',
        'thumbnail',
        'thumbnails'
      ]);
      playlist["description"] = nav(header, ['description', 'runs', 0, 'text']);
      int runCount = header['subtitle']['runs'].length;
      if (runCount > 1) {
        playlist['author'] = {
          'name': nav(header, ['subtitle', 'runs', 2, 'text']),
          'browseId': nav(header, [
            'subtitle',
            'runs',
            2,
            'navigationEndpoint',
            'browseEndpoint',
            'browseId'
          ])
        };
        if (runCount == 5) {
          playlist['year'] = nav(header, ['subtitle', 'runs', 4, 'text']);
        }
      }
      playlist['trackCount'] = int.parse(header['secondSubtitle']['runs'][0]
              ['text']
          .split(' ')[0]
          .replaceAll(',', ''));
      if (header['secondSubtitle']['runs'].length > 1) {
        playlist['duration'] = header['secondSubtitle']['runs'][2]['text'];
      }
      // playlist['data'] = finalResults['contents'];
      playlist['tracks'] = [];
      for (Map result in finalResults['contents']) {
        if (result['musicResponsiveListItemRenderer'] == null) {
          continue;
        }
        Map data = result['musicResponsiveListItemRenderer'];
        String? videoId = nav(data, ['playlistItemData', 'videoId']);
        if (videoId == null) {
          continue;
        }
        List artists = [];
        Map? album;
        String title = nav(data, [
          'flexColumns',
          0,
          'musicResponsiveListItemFlexColumnRenderer',
          'text',
          'runs',
          0,
          'text'
        ]);
        if (title == 'Song deleted') {
          continue;
        }
        final List thumbnails = nav(data,
            ['thumbnail', 'musicThumbnailRenderer', 'thumbnail', 'thumbnails']);
        final List subtitleList = nav(data, [
          'flexColumns',
          1,
          'musicResponsiveListItemFlexColumnRenderer',
          'text',
          'runs'
        ]) as List;

        for (final element in subtitleList) {
          if (element['navigationEndpoint']?['browseEndpoint']
                          ?['browseEndpointContextSupportedConfigs']
                      ['browseEndpointContextMusicConfig']['pageType']
                  .toString()
                  .trim() ==
              'MUSIC_PAGE_TYPE_USER_CHANNEL') {
            artists.add({
              'name': element['text'],
              'browseId': element['navigationEndpoint']?['browseEndpoint']
                  ?['browseId']
            });
          }
        }

        Map results = {
          'videoId': videoId,
          'title': title,
          'thumbnails': thumbnails,
          'artists': artists,
        };
        playlist['tracks'].add(results);
      }

      return playlist;
    } catch (e) {
      log('Error in ytmusic getPlaylistDetails $e');
      return {};
    }
  }
}
