import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../services/media_player.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../browse_screen/browse_screen.dart';

class YTMSongTile extends StatelessWidget {
  const YTMSongTile(
      {required this.items,
      required this.index,
      this.mainBrowse = false,
      super.key});
  final List items;
  final int index;
  final bool mainBrowse;
  @override
  Widget build(BuildContext context) {
    Map item = items[index];
    return AdaptiveListTile(
      margin: const EdgeInsets.symmetric(vertical: 4),
      onTap: () {
        if (item['videoId'] != null) {
          GetIt.I<MediaPlayer>().playAll(List.from(items), index: index);
        } else {
          Navigator.push(
            context,
            AdaptivePageRoute.create(
              (context) => BrowseScreen(
                  endpoint: item['endpoint'].cast<String, dynamic>()),
            ),
          );
        }
      },
      title: Text(
        item['title'],
        maxLines: 2,
      ),
      leading: ClipRRect(
          borderRadius:
              BorderRadius.circular(item['type'] == 'ARTIST' ? 50 : 3),
          child: CachedNetworkImage(
            imageUrl: item['thumbnails']
                .first['url']
                .replaceAll('w540-h225', 'w60-h60'),
            height: 50,
            width: 50,
          )),
      subtitle: Text(
        item['subtitle'] ?? '',
        maxLines: 1,
      ),
      trailing:
          item['videoId'] == null ? Icon(AdaptiveIcons.chevron_right) : null,
    );
  }
}
