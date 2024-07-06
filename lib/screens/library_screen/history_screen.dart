import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../generated/l10n.dart';
import '../../utils/bottom_modals.dart';
import '../home_screen/section_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).history),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ValueListenableBuilder(
            valueListenable: Hive.box('SONG_HISTORY').listenable(),
            builder: (context, box, child) {
              List songs = box.values.toList();
              songs.sort((a, b) =>
                  (b['updatedAt'] ?? 0).compareTo((a['updatedAt'] ?? 0)));
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: songs.map((song) {
                  return SwipeActionCell(
                    key: ObjectKey(song['videoId']),
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "Remove",
                          onTap: (CompletionHandler handler) async {
                            Modals.showConfirmBottomModal(
                              context,
                              message: 'Are you sure you want to remove it?',
                              isDanger: true,
                            ).then((bool confirm) async {
                              if (confirm) {
                                await box.delete(song['videoId']);
                              }
                            });
                          },
                          color: Colors.red),
                    ],
                    child: SongTile(song: song),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
