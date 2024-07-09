import 'dart:collection';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gyawun_beta/utils/extensions.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../services/library.dart';
import '../../themes/colors.dart';
import '../../utils/bottom_modals.dart';
import '../browse_screen/browse_screen.dart';
import 'favourite_details_screen.dart';
import 'history_screen.dart';
import 'playlist_details_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map playlists = context.watch<LibraryService>().playlists;
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).saved),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              AdaptiveListTile(
                margin: const EdgeInsets.symmetric(vertical: 4),
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
                trailing: Icon(AdaptiveIcons.chevron_right),
                onTap: () => Navigator.push(
                    context,
                    AdaptivePageRoute.create(
                      (context) => const FavouriteDetailsScreen(),
                    )),
              ),
              AdaptiveListTile(
                margin: const EdgeInsets.symmetric(vertical: 4),
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
                trailing: Icon(AdaptiveIcons.chevron_right),
                onTap: () => Navigator.push(
                    context,
                    AdaptivePageRoute.create(
                      (context) => const HistoryScreen(),
                    )),
              ),
              Column(
                children: SplayTreeMap.from(playlists)
                    .map((key, item) {
                      return MapEntry(
                        key,
                        item == null
                            ? const SizedBox.shrink()
                            : AdaptiveListTile(
                                margin: const EdgeInsets.symmetric(vertical: 4),
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
                                      AdaptivePageRoute.create(
                                        (context) => BrowseScreen(
                                            endpoint: item['endpoint']
                                                .cast<String, dynamic>()),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      AdaptivePageRoute.create(
                                        (context) => PlaylistDetailsScreen(
                                            playlistkey: key),
                                      ),
                                    );
                                  }
                                },
                                title: Text(
                                  item['title'],
                                  maxLines: 2,
                                ),
                                leading: item['isPredefined'] == true ||
                                        (item['songs'] != null &&
                                            item['songs']?.length > 0)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            item['type'] == 'ARTIST' ? 50 : 3),
                                        child: item['isPredefined'] == true
                                            ? CachedNetworkImage(
                                                imageUrl: item['thumbnails']
                                                    .first['url']
                                                    .replaceAll(
                                                        'w540-h225', 'w60-h60'),
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
                                                  children:
                                                      (item['songs'] as List)
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
                                trailing: Icon(AdaptiveIcons.chevron_right),
                              ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: ExpandableFab(
      //   openButtonBuilder: RotateFloatingActionButtonBuilder(
      //     child: const Icon(CupertinoIcons.add),
      //   ),
      //   closeButtonBuilder: DefaultFloatingActionButtonBuilder(
      //     child: const Icon(CupertinoIcons.clear),
      //   ),
      //   distance: 70,
      //   type: ExpandableFabType.up,
      //   children: [
      //     FloatingActionButton.small(
      //       onPressed: () {
      //         Modals.showCreateplaylistModal(context);
      //       },
      //       child: const Icon(CupertinoIcons.create),
      //     ),
      //     FloatingActionButton.small(
      //       onPressed: () {
      //         Modals.showImportplaylistModal(context);
      //       },
      //       child: const Icon(Icons.import_export),
      //     ),
      //   ],
      // ),
    );
  }
}
