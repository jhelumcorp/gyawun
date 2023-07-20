import 'package:flutter/material.dart';
import 'package:gyavun/components/search_tile.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:metadata_god/metadata_god.dart';

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
          List keys = box.keys.toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              String? path = items[index]['path'];
              dynamic id = keys[index];
              return items[index]['status'] == 'done'
                  ? FutureBuilder(
                      future: MetadataGod.readMetadata(file: path!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Metadata metadata = snapshot.data!;
                          return DownloadTile(
                            id: id,
                            path: path,
                            keys: keys,
                            metadata: metadata,
                            index: index,
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
