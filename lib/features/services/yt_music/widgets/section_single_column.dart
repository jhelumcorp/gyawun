// import 'package:flutter/material.dart';
// import 'package:ytmusic/models/yt_item.dart';

// import 'section_column_tile.dart';

// class SectionSingleColumn extends StatelessWidget {
//   const SectionSingleColumn({super.key, required this.items});

//   final List<YTItem> items;

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
//             child: SectionColumnTile(
//               item: items[index],
//               isFirst: index == 0,
//               isLast: index == items.length - 1,
//             ),
//           );
//         },
//         childCount: items.length,
//         addAutomaticKeepAlives: false,
//       ),
//     );
//   }
// }
