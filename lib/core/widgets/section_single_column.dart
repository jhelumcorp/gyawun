import 'package:flutter/material.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

import 'tiles/section_column_title.dart';

class SectionSingleColumn extends StatelessWidget {
  const SectionSingleColumn({super.key, required this.items});

  final List<SectionItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            child: SectionColumnTile(
              item: items[index],
              items: items.whereType<PlayableItem>().toList(),
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
