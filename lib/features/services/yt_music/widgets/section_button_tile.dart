// import 'package:flutter/material.dart';
// import 'package:ytmusic/models/yt_item.dart';

// import '../browse/yt_browse_screen.dart';

// class SectionButtonTile extends StatelessWidget {
//   const SectionButtonTile({super.key, required this.item});
//   final YTItem item;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       elevation: 0,
//       shadowColor: Colors.transparent,
//       surfaceTintColor: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),

//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   YTBrowseScreen(body: item.endpoint, title: item.title),
//             ),
//           );
//         },
//         child: Ink(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surfaceContainer,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             item.title,
//             style: Theme.of(context).textTheme.labelLarge,
//             maxLines: 1,
//           ),
//         ),
//       ),
//     );
//   }
// }
