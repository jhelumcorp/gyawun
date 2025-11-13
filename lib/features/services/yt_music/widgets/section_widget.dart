// import 'package:flutter/material.dart';
// import 'package:gyawun_dataproviders_base/gyawun_dataproviders_base.dart';
// import 'package:gyawun_music/core/widgets/carousel_card.dart';
// import 'package:gyawun_music/core/widgets/section_header.dart';
// import 'package:gyawun_music/core/widgets/section_single_column.dart';
// import 'package:gyawun_music/features/services/yt_music/widgets/section_grid.dart';
// import 'package:gyawun_music/features/services/yt_music/widgets/section_multi_column.dart';
// import 'package:gyawun_music/features/services/yt_music/widgets/section_multi_column_row.dart';
// import 'package:sliver_tools/sliver_tools.dart';

// class SectionsWidget extends StatelessWidget {
//   const SectionsWidget({super.key, required this.sections});
//   final List<Section> sections;

//   @override
//   Widget build(BuildContext context) {
//     final carouselSection =
//         (sections.first.type == SectionType.row || sections.first.type == SectionType.multiColumn)
//         ? sections.first
//         : null;
//     return MultiSliver(
//       children: [
//         if (carouselSection != null &&
//             ((carouselSection.title ?? '').isNotEmpty || carouselSection.trailing != null))
//           SectionHeader(section: carouselSection),

//         if (carouselSection != null)
//           SliverToBoxAdapter(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxHeight: 300),
//               child: CarouselView(
//                 itemExtent: 300,
//                 shrinkExtent: 100,
//                 children: sections[0].items.map((item) => CarouselCard(item: item)).toList(),
//               ),
//             ),
//           ),
//         for (final section in (carouselSection != null ? sections.sublist(1) : sections)) ...[
//           if ((section.title != null && section.title!.isNotEmpty) || section.trailing != null)
//             SectionHeader(section: section),

//           if (section.type == SectionType.multiColumn)
//             SectionMultiColumn(items: section.items, maxItem: section.itemsPerColumn),

//           if (section.type == SectionType.singleColumn) SectionSingleColumn(items: section.items),

//           if (section.type == SectionType.grid) SectionGrid(items: section.items),
//           if (section.type == SectionType.multiColumnRow)
//             SectionMultiColumnRow(items: section.items),
//         ],
//       ],
//     );
//   }
// }
