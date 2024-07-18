import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../generated/l10n.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../utils/bottom_modals.dart';
import 'library_tile.dart';
import 'playlist_details_screen.dart';

class FavouriteDetailsScreen extends StatelessWidget {
  const FavouriteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).Favourites),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                MyPlayistHeader(
                  playlist: {'songs': Hive.box('FAVOURITES').values.toList()},
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box('FAVOURITES').listenable(),
                  builder: (context, box, child) {
                    Map<String, dynamic> songs = Map.from(box.toMap());
                    return Column(
                      children: songs
                          .map((key, song) {
                            return MapEntry(
                                key,
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: SwipeActionCell(
                                    key: ObjectKey(key),
                                    backgroundColor: Colors.transparent,
                                    trailingActions: <SwipeAction>[
                                      SwipeAction(
                                          title: S.of(context).Remove,
                                          onTap: (CompletionHandler
                                              handler) async {
                                            Modals.showConfirmBottomModal(
                                                    context,
                                                    message: S
                                                        .of(context)
                                                        .Remove_Message,
                                                    isDanger: true)
                                                .then(
                                              (bool confirm) async {
                                                if (confirm) {
                                                  await box.delete(key);
                                                }
                                              },
                                            );
                                          },
                                          color: Colors.red),
                                    ],
                                    child: LibraryTile(
                                      songs: box.values.toList(),
                                      index: box.values.toList().indexOf(song),
                                    ),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
