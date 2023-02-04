import 'endpoints/search.dart';

import 'endpoints/playlist.dart';
import 'endpoints/suggestions.dart';

class YTMUSIC {
  static search(query,
          {String? filter, String? scope, ignoreSpelling = false}) =>
      Search().search(query,
          filter: filter, scope: scope, ignoreSpelling: ignoreSpelling);
  static Future suggestions(query) =>
      Suggestions().getSearchSuggestions(query: query);
  static Future getPlaylistDetails(playlistId) =>
      Playlist().getPlaylistDetails(playlistId);
}
