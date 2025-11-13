import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/tiles/section_button_tile.dart' show SectionButtonTile;
import 'package:gyawun_music/core/widgets/tiles/section_grid_tile.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class SectionGrid extends StatelessWidget {
  const SectionGrid({super.key, required this.items});
  final List<SectionItem> items;

  @override
  Widget build(BuildContext context) {
    const spacing = 8.0;
    final buttonItems = items.where((item) => item.type == SectionItemType.button).toList();
    final visualItems = items.where((item) => item.type != SectionItemType.button).toList();

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
                children: [for (final item in buttonItems) SectionButtonTile(item: item)],
              ),

            if (visualItems.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;

                  const desiredItemWidth = 200;
                  final crossAxisCount = ((availableWidth - spacing) / (desiredItemWidth))
                      .floor()
                      .clamp(2, visualItems.length);

                  final tileWidth = (availableWidth * (crossAxisCount - 1)) / crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.start,
                    children: [
                      for (final item in visualItems)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: tileWidth.clamp(140.0, 350.0)),
                          child: SectionGridTile(item: item, width: tileWidth.clamp(140.0, 350.0)),
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
