import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ytmusic/ytmusic.dart';
import 'package:ytmusic/enums/section_type.dart';

import 'section_grid.dart';
import 'section_header.dart';
import 'section_multi_column.dart';
import 'section_row.dart';
import 'section_single_column.dart';

class SectionsWidget extends StatelessWidget {
  final List<YTSection> sections;

  const SectionsWidget({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: 
        [
          for (final section in sections) ...[
            if (section.title.isNotEmpty || section.trailing != null)
              SectionHeader(section: section),

            if (section.type == YTSectionType.row)
              SectionRow(items: section.items),

            if (section.type == YTSectionType.multiColumn)
              SectionMultiColumn(items: section.items),

            if (section.type == YTSectionType.singleColumn)
              SectionSingleColumn(items: section.items),

            if (section.type == YTSectionType.grid)
              SectionGrid(items: section.items),
          ],
        ],
      );
  }
}
