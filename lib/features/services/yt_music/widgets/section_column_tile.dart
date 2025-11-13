// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gyawun_music/core/utils/modals.dart';
// import 'package:gyawun_music/features/services/yt_music/utils/click_handler.dart';
// import 'package:ytmusic/mixins/mixins.dart';
// import 'package:ytmusic/models/yt_item.dart';

// class SectionColumnTile extends StatelessWidget {
//   const SectionColumnTile({
//     super.key,
//     required this.item,
//     this.onTap,
//     this.isFirst = false,
//     this.isLast = false,
//   });
//   final YTItem item;
//   final void Function()? onTap;
//   final bool isFirst;
//   final bool isLast;

//   void playSong(BuildContext context, YTItem item) {}

//   @override
//   Widget build(BuildContext context) {
//     final pixelRatio = MediaQuery.devicePixelRatioOf(context);
//     final thumbnail = item is HasThumbnail
//         ? (item as HasThumbnail).thumbnails.firstOrNull
//         : null;

//     return Material(
//       color: Colors.transparent,
//       elevation: 0,
//       shadowColor: Colors.transparent,
//       surfaceTintColor: Colors.transparent,
//       child: ListTile(
//         onTap: () {
//           onYTSectionItemTap(context, item);
//         },
//         onLongPress: () {
//           Modals.showItemBottomSheet(context, item);
//         },
//         enableFeedback: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadiusGeometry.only(
//             topLeft: Radius.circular(isFirst ? 20 : 4),
//             topRight: Radius.circular(isFirst ? 20 : 4),
//             bottomLeft: Radius.circular(isLast ? 20 : 4),
//             bottomRight: Radius.circular(isLast ? 20 : 4),
//           ),
//         ),
//         tileColor: Theme.of(context).colorScheme.surfaceContainer,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: thumbnail?.url == null
//             ? null
//             : SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: AspectRatio(
//                   aspectRatio: item is YTVideo ? 16 / 9 : 1,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(
//                         item is YTArtist ? ((50 * pixelRatio).round() / 2) : 8,
//                       ),
//                       image: DecorationImage(
//                         image: CachedNetworkImageProvider(
//                           thumbnail!.url,
//                           maxHeight: (50 * pixelRatio).round(),
//                           maxWidth: (50 * pixelRatio).round(),
//                         ),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//         title: Text(
//           item.title,
//           maxLines: 1,
//           style: Theme.of(
//             context,
//           ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
//         ),
//         subtitle: Text(
//           item.subtitle,
//           maxLines: 1,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
//           ),
//         ),
//         trailing: IconButton(
//           onPressed: () {
//             Modals.showItemBottomSheet(context, item);
//           },
//           icon: const Icon(Icons.more_vert_rounded),
//         ),
//       ),
//     );
//   }
// }
