import 'dart:collection';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gyawun_beta/generated/l10n.dart';
import 'package:gyawun_beta/screens/browse_screen/browse_screen.dart';
import 'package:gyawun_beta/screens/library_screen/favourite_details_screen.dart';
import 'package:gyawun_beta/screens/library_screen/history_screen.dart';
import 'package:gyawun_beta/screens/library_screen/playlist_details_screen.dart';
import 'package:gyawun_beta/services/library.dart';
import 'package:gyawun_beta/themes/colors.dart';
import 'package:gyawun_beta/utils/bottom_modals.dart';
import 'package:gyawun_beta/utils/extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class LocalLibrary extends StatelessWidget {
  const LocalLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    Map playlists = context.watch<LibraryService>().playlists;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(S.of(context).favourites),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  CupertinoIcons.heart_fill,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: ValueListenableBuilder(
                valueListenable: Hive.box('FAVOURITES').listenable(),
                builder: (context, box, child) {
                  return Text('${box.length} ${S.of(context).songs}');
                },
              ),
              trailing: const Icon(CupertinoIcons.chevron_right),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const FavouriteDetailsScreen(),
                  )),
            ),
            ListTile(
              title: Text(S.of(context).history),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  Icons.history,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: ValueListenableBuilder(
                valueListenable: Hive.box('SONG_HISTORY').listenable(),
                builder: (context, box, child) {
                  return Text('${box.length} ${S.of(context).songs}');
                },
              ),
              trailing: const Icon(CupertinoIcons.chevron_right),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HistoryScreen(),
                  )),
            ),
            Column(
              children: SplayTreeMap.from(playlists)
                  .map((key, item) {
                    return MapEntry(
                      key,
                      item == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onSecondaryTap: () {
                                  if (item['videoId'] == null &&
                                      item['playlistId'] != null) {
                                    Modals.showPlaylistBottomModal(
                                        context, item);
                                  } else if (item['isPredefined'] == false) {
                                    Modals.showPlaylistBottomModal(
                                        context, {...item, 'playlistId': key});
                                  }
                                },
                                onLongPress: () {
                                  if (item['videoId'] == null &&
                                      item['playlistId'] != null) {
                                    Modals.showPlaylistBottomModal(
                                        context, item);
                                  } else if (item['isPredefined'] == false) {
                                    Modals.showPlaylistBottomModal(
                                        context, {...item, 'playlistId': key});
                                  }
                                },
                                onTap: () {
                                  if (item['isPredefined']) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => BrowseScreen(
                                              endpoint: item['endpoint']
                                                  .cast<String, dynamic>()),
                                        ));
                                  } else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                PlaylistDetailsScreen(
                                                    playlistkey: key)));
                                  }
                                },
                                child: ListTile(
                                  title: Text(
                                    item['title'],
                                    maxLines: 2,
                                  ),
                                  leading: item['isPredefined'] == true ||
                                          (item['songs'] != null &&
                                              item['songs']?.length > 0)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              item['type'] == 'ARTIST'
                                                  ? 50
                                                  : 3),
                                          child: item['isPredefined'] == true
                                              ? CachedNetworkImage(
                                                  imageUrl: item['thumbnails']
                                                      .first['url']
                                                      .replaceAll('w540-h225',
                                                          'w60-h60'),
                                                  height: 50,
                                                  width: 50,
                                                )
                                              : SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: StaggeredGrid.count(
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    crossAxisCount:
                                                        item['songs'].length > 1
                                                            ? 2
                                                            : 1,
                                                    children: (item['songs']
                                                            as List)
                                                        .sublist(
                                                            0,
                                                            min(
                                                                item['songs']
                                                                    .length,
                                                                4))
                                                        .indexed
                                                        .map((ind) {
                                                      int index = ind.$1;
                                                      Map song = ind.$2;
                                                      return CachedNetworkImage(
                                                        imageUrl:
                                                            song['thumbnails']
                                                                .first['url']
                                                                .replaceAll(
                                                                    'w540-h225',
                                                                    'w60-h60'),
                                                        height: (item['songs']
                                                                        .length <=
                                                                    2 ||
                                                                (item['songs']
                                                                            .length ==
                                                                        3 &&
                                                                    index == 0))
                                                            ? 50
                                                            : null,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: greyColor,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Icon(
                                            CupertinoIcons.music_note_list,
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                  subtitle: (item['songs'] != null ||
                                          item['isPredefined'])
                                      ? Text(
                                          item['isPredefined'] == true
                                              ? item['subtitle']
                                              : '${item['songs'].length} ${S.of(context).songs}',
                                          maxLines: 1,
                                        )
                                      : null,
                                  trailing:
                                      const Icon(CupertinoIcons.chevron_right),
                                ),
                              ),
                            ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
