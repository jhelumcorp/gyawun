import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/widgets/TrackTile.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Favorites"),
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
                "Nothing Here",
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
            );
          }
          return ListView(
            children: favourites.map((track) {
              Map<String, dynamic> newMap = jsonDecode(jsonEncode(track));
              return TrackTile(track: newMap);
            }).toList(),
          );
        },
      ),
    );
  }
}
