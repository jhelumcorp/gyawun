import 'package:flutter/material.dart';
import 'package:gyawun_music/core/widgets/tiles/section_button_tile.dart' show SectionButtonTile;
import 'package:gyawun_music/core/widgets/tiles/section_grid_tile.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class SectionGrid extends StatelessWidget {
  const SectionGrid({super.key, required this.items});
  final List<SectionItem> items;

  @override
  Widget build(BuildContext context) {
    final buttonItems = items.where((item) => item.type == SectionItemType.button).toList();
    final visualItems = items.where((item) => item.type != SectionItemType.button).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Button items section
          if (buttonItems.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: buttonItems.map((item) => SectionButtonTile(item: item)).toList(),
            ),
            const SizedBox(height: 8),
          ],

          // Visual items - perfect grid with full width usage
          if (visualItems.isNotEmpty) _PerfectGrid(items: visualItems),
        ]),
      ),
    );
  }
}

class _PerfectGrid extends StatelessWidget {
  const _PerfectGrid({required this.items});
  final List<SectionItem> items;

  double _getBaseItemWidth(SectionItem item, bool isWideScreen) {
    final isHorizontal =
        (item.type == SectionItemType.video || item.type == SectionItemType.episode);
    final imageHeight = isWideScreen ? 200.0 : 150.0;
    return isHorizontal ? imageHeight * (16 / 9) : imageHeight;
  }

  List<List<SectionItem>> _calculateRows(
    List<SectionItem> items,
    double availableWidth,
    bool isWideScreen,
  ) {
    final rows = <List<SectionItem>>[];
    var currentRow = <SectionItem>[];
    var currentRowWidth = 0.0;
    const spacing = 8.0;
    const tilePadding = 16.0; // 8 padding on each side
    const maxItemsPerRow = 6; // Maximum items per row

    for (var item in items) {
      final itemWidth = _getBaseItemWidth(item, isWideScreen) + tilePadding;
      final widthWithSpacing = currentRow.isEmpty ? itemWidth : itemWidth + spacing;

      // Check both width constraint AND max items per row
      if ((currentRow.isEmpty || currentRowWidth + widthWithSpacing <= availableWidth) &&
          currentRow.length < maxItemsPerRow) {
        currentRow.add(item);
        currentRowWidth += widthWithSpacing;
      } else {
        rows.add(currentRow);
        currentRow = [item];
        currentRowWidth = itemWidth;
      }
    }

    if (currentRow.isNotEmpty) {
      rows.add(currentRow);
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        final availableWidth = constraints.maxWidth;
        final rows = _calculateRows(items, availableWidth, isWideScreen);
        const spacing = 8.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.map((rowItems) {
            // Calculate total base width and spacing
            final totalBaseWidth = rowItems.fold<double>(
              0,
              (sum, item) =>
                  sum + _getBaseItemWidth(item, isWideScreen) + 16, // +16 for tile padding
            );
            final totalSpacing = (rowItems.length - 1) * spacing;
            final remainingWidth = availableWidth - totalBaseWidth - totalSpacing;
            final extraWidthPerItem = remainingWidth / rowItems.length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < rowItems.length; i++) ...[
                    Expanded(
                      flex: (_getBaseItemWidth(rowItems[i], isWideScreen) + extraWidthPerItem)
                          .round(),
                      child: SectionGridTile(item: rowItems[i]),
                    ),
                    if (i < rowItems.length - 1) const SizedBox(width: spacing),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
