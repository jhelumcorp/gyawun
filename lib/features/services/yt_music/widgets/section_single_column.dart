import 'package:flutter/material.dart';
import 'package:ytmusic/models/section.dart';

import 'section_column_tile.dart';
import 'section_multi_row_column.dart';

class SectionSingleColumn extends StatelessWidget {
  const SectionSingleColumn({super.key, required this.items});

  final List<YTSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (items[index].desctiption != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SectionMultiRowColumn(item: items[index]),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            child: SectionColumnTile(
              item: items[index],
              isFirst: index == 0,
              isLast: index == items.length - 1,
            ),
          );
        },
        childCount: items.length,
        addAutomaticKeepAlives: false,
      ),
    );
  }
}