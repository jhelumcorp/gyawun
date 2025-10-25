import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:ytmusic/models/yt_item.dart';

import 'section_grid_tile.dart';

class SectionGrid extends StatelessWidget {
  final List<YTItem> items;

  const SectionGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final desiredItemWidth = context.isWideScreen ? 200.0 : 150.0;
    final itemHeight = context.isWideScreen ? 236.0 : 186.0;
    final crossAxisSpacing = 8.0;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.crossAxisExtent;

        final crossAxisCount =
            (availableWidth + crossAxisSpacing) ~/
            (desiredItemWidth + crossAxisSpacing);
        final effectiveCrossAxisCount = crossAxisCount.clamp(1, items.length);
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => SectionGridTile(
              item: items[index],
              width: desiredItemWidth,
              height: itemHeight,
            ),
            childCount: items.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: effectiveCrossAxisCount,
            childAspectRatio: 0.79,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 8,
          ),
        );
      },
    );
  }
}