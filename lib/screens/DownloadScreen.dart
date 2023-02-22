import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/utils/file.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Downloads"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('downloads').listenable(),
        builder: (BuildContext context, Box box, child) {
          List favourites = box.values.toList();
          for (var element in favourites) {
            File(element?['path'] ?? "").exists().then((value) => {
                  if (!value && element['progress'] == 100)
                    {box.delete(element['videoId'])}
                });
          }

          if (favourites.isEmpty) {
            return Center(
              child: Text(
                S.of(context).Nothing_Here,
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
            );
          }
          return ListView(
            children: favourites.map((track) {
              Map<String, dynamic> newMap = jsonDecode(jsonEncode(track));

              return SwipeActionCell(
                trailingActions: [
                  SwipeAction(
                      icon: const Icon(Icons.delete_rounded),
                      title: "DELETE",
                      onTap: (CompletionHandler handler) async {
                        await handler(true);
                        await deleteFile(newMap['videoId']);
                      },
                      color: Colors.red),
                ],
                key: Key("$newMap['videoId']"),
                child: DownloadTile(
                  tracks:
                      favourites.map((e) => jsonDecode(jsonEncode(e))).toList(),
                  index: favourites.indexOf(track),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
