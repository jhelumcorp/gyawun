import 'package:gyawun/api/extensions.dart';

String getSubTitle(Map item) {
  final type = item['type'];
  switch (type) {
    case 'charts':
      return '';
    case 'radio_station':
      return 'Radio • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle']?.toString().unescape()}';
    case 'playlist':
      return 'Playlist • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle'].toString().unescape()}';
    case 'song':
      return 'Single • ${item['artist']?.toString().unescape()}';
    case 'mix':
      return 'Mix • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle'].toString().unescape()}';
    case 'show':
      return 'Podcast • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle'].toString().unescape()}';
    case 'album':
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      if (artists != null) {
        return 'Album • ${artists?.join(', ')?.toString().unescape()}';
      } else if (item['subtitle'] != null && item['subtitle'] != '') {
        return 'Album • ${item['subtitle']?.toString().unescape()}';
      }
      return 'Album';
    default:
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      return artists?.join(', ')?.toString().unescape() ?? '';
  }
}
