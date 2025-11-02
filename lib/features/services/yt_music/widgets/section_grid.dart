import 'package:flutter/material.dart';
import 'package:ytmusic/models/yt_item.dart';
import 'section_button_tile.dart';
import 'section_grid_tile.dart';

class SectionGrid extends StatelessWidget {
  final List<YTItem> items;

  const SectionGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const spacing = 8.0;
    final buttonItems = items.whereType<YTButtonItem>().toList();
    final visualItems = items.where((e) => e is! YTButtonItem).toList();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (buttonItems.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: [
                  for (final item in buttonItems)
                    SectionButtonTile(item: item),
                ],
              ),

            if (visualItems.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  
                  final desiredItemWidth = 200;
                  final crossAxisCount =
                      ((availableWidth - spacing) / (desiredItemWidth ))
                          .floor()
                          .clamp(2, visualItems.length);

                  final tileWidth = (availableWidth * (crossAxisCount - 1)) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.start,
                    children: [
                      for (final item in visualItems)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: tileWidth.clamp(140.0, 350.0),
                          ),
                          child: SectionGridTile(item: item,width: tileWidth.clamp(140.0, 350.0),),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}