import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gyawun/components/search_tile.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/downlod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../generated/l10n.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Future<bool> exist(String path, String k) async {
    File file = File(path);
    bool exists = await file.exists();
    if (!exists) {
      await deleteSong(key: k, path: path);
    }
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).downloads,
            style: mediumTextStyle(context, bold: false)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('downloads').listenable(),
        builder: (context, box, child) {
          List items = box.values.toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index]['status'] == 'done'
                  ? FutureBuilder(
                      future: exist(items[index]['path'], items[index]['id']),
                      builder: (context, snaps) {
                        if (snaps.hasData && snaps.data!) {
                          return FutureBuilder(
                              future: getImageUri(items[index]['id']),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DownloadTile(
                                    items: List.from(items),
                                    index: index,
                                    image: snapshot.data!,
                                  );
                                }
                                return const SizedBox();
                              });
                        }
                        return const SizedBox();
                      })
                  : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
