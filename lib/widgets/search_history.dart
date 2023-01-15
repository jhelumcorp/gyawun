import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/generated/l10n.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({this.onTap, this.onTrailing, super.key});

  final Function? onTap;
  final Function? onTrailing;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, child) {
          TextDirection direction =
              box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr;
          return ValueListenableBuilder(
            valueListenable: Hive.box('search_history').listenable(),
            builder: (context, Box box, child) {
              List keys = box.keys.toList().reversed.toList();
              List values = box.values.toList().reversed.toList();
              return Directionality(
                textDirection: direction,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    dynamic key = keys[index];
                    String e = values[index];
                    return ListTile(
                      enableFeedback: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      visualDensity: VisualDensity.compact,
                      leading: Icon(CupertinoIcons.arrow_counterclockwise,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyLarge
                              ?.color),
                      title: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (onTap != null) {
                                  onTap!(e);
                                }
                              },
                              child: Text(
                                e,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              box.delete(key);
                            },
                            icon: Icon(CupertinoIcons.xmark,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge
                                    ?.color),
                          ),
                          IconButton(
                            onPressed: () {
                              onTrailing != null ? onTrailing!(e) : () {};
                            },
                            icon: Icon(
                                box.get('textDirection', defaultValue: 'ltr') ==
                                        'rtl'
                                    ? CupertinoIcons.arrow_up_right
                                    : CupertinoIcons.arrow_up_left,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge
                                    ?.color),
                          ),
                        ],
                      ),
                      dense: true,
                    );
                  },
                ),
              );
            },
          );
        });
  }
}
