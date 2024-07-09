import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../generated/l10n.dart';
import '../../utils/bottom_modals.dart';
import 'library_tile.dart';
import 'playlist_details_screen.dart';

class FavouriteDetailsScreen extends StatelessWidget {
  const FavouriteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).favourites),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              MyPlayistHeader(
                playlist: {'songs': Hive.box('FAVOURITES').values.toList()},
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box('FAVOURITES').listenable(),
                builder: (context, box, child) {
                  Map songs = box.toMap();
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
                                        title: "Remove",
                                        onTap:
                                            (CompletionHandler handler) async {
                                          Modals.showConfirmBottomModal(context,
                                                  message:
                                                      'Are you sure you want to remove it?',
                                                  isDanger: true)
                                              .then((bool confirm) async {
                                            if (confirm) {
                                              await box.delete(key);
                                            }
                                          });
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
    );
  }
}
