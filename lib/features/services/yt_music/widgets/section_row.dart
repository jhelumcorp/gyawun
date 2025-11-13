// import 'package:flutter/material.dart';
// import 'package:gyawun_music/core/extensions/context_extensions.dart';
// import 'package:ytmusic/models/yt_item.dart';

// import 'section_row_tile.dart';

// class SectionRow extends StatelessWidget {
//   const SectionRow({super.key, required this.items});

//   final List<YTItem> items;

//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: context.isWideScreen ? 270 : 216,
//         child: ListView.separated(
//           addAutomaticKeepAlives: false,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           scrollDirection: Axis.horizontal,
//           itemCount: items.length,
//           separatorBuilder: (context, index) => const SizedBox(width: 4),
//           itemBuilder: (context, index) {
//             final item = items[index];

//             return SectionRowTile(item: item);
//           },
//         ),
//       ),
//     );
//   }
// }
