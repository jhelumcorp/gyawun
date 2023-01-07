import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.of(context).My_Favorites),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('myfavourites').listenable(),
        builder: (BuildContext context, Box box, child) {
          List favourites = box.values.toList();
          favourites.sort((a, b) => a['timeStamp'].compareTo(b['timeStamp']));
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

              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key("$newMap['videoId']"),
                onDismissed: (direction) {
                  box.delete(newMap['videoId']);
                },
                background: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      S.of(context).Remove_from_favorites,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodyLarge
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                child: TrackTile(track: newMap),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
