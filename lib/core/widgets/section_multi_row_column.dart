import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/tiles/section_button_tile.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class SectionMultiColumnRow extends StatelessWidget {
  const SectionMultiColumnRow({super.key, required this.items});
  final List<SectionItem> items;

  @override
  Widget build(BuildContext context) {
    final num = (items.length <= 5 ? items.length : 4);
    var pages = items.length ~/ num;
    pages = (pages * num) < items.length ? pages + 1 : pages;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 260,
        child: ListView.builder(
          itemCount: pages,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            int start = index * num;
            int end = start + num;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.sublist(start, min(end, items.length)).indexed.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SectionButtonTile(item: entry.$2),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
