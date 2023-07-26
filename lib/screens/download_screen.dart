import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gyawun/components/search_tile.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/downlod.dart';
import 'package:hive_flutter/adapters.dart';

import '../generated/l10n.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

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
                      future: File(items[index]['path']).exists(),
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
                                if (snapshot.hasError) {
                                  box.delete(box.keyAt(index));
                                }
                                return const SizedBox();
                              });
                        }
                        if (snaps.hasError) {
                          deleteSong(
                              key: box.keyAt(index),
                              path: items[index]['path']);
                          box.delete(box.keyAt(index));
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
