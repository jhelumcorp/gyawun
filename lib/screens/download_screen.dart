import 'package:flutter/material.dart';
import 'package:gyavun/components/search_tile.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/downlod.dart';
import 'package:hive_flutter/adapters.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads', style: mediumTextStyle(context, bold: false)),
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
                      })
                  : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
