// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gyawun_music/core/extensions/context_extensions.dart';
// import 'package:readmore/readmore.dart';
// import 'package:ytmusic/models/browse_page.dart';

// class PageHeader extends StatelessWidget {
//   const PageHeader({super.key, required this.header});
//   final YTPageHeader header;

//   List<Widget> _drawItems(BuildContext context) {
//     final thumbnail = header.thumbnails.lastOrNull;
//     return [
//       if (thumbnail?.url != null)
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: CachedNetworkImage(imageUrl: thumbnail!.url, height: 300, width: 300),
//         ),
//       SizedBox(height: context.isWideScreen ? 0 : 16, width: context.isWideScreen ? 16 : 0),
//       context.isWideScreen ? Expanded(child: _drawDescription(context)) : _drawDescription(context),
//     ];
//   }

//   Widget _drawDescription(BuildContext context) {
//     return Column(
//       crossAxisAlignment: context.isWideScreen
//           ? CrossAxisAlignment.start
//           : CrossAxisAlignment.center,
//       children: [
//         if (header.title.isNotEmpty)
//           Text(header.title, style: Theme.of(context).textTheme.headlineMedium),

//         if (header.subtitle.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Text(header.subtitle, style: Theme.of(context).textTheme.bodyLarge),
//           ),
//         if (header.secondSubtitle.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: Text(header.secondSubtitle, style: Theme.of(context).textTheme.bodyLarge),
//           ),
//         if (header.description.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: ReadMoreText(
//               header.description,
//               trimMode: TrimMode.Length,
//               style: Theme.of(context).textTheme.bodyLarge,
//               trimLines: 3,
//             ),
//           ),
//         const SizedBox(height: 4),
//         Wrap(
//           spacing: 4,
//           runSpacing: 4,
//           children: [
//             if (header.playEndpoint != null)
//               FilledButton.icon(
//                 onPressed: () async {
//                   // BottomSnackbar.showMessage(context, "Play starting");
//                   // await sl<MediaPlayer>().playYTFromEndpoint(
//                   //   header.playEndpoint!,
//                   // );
//                 },
//                 label: const Text("Play"),
//                 icon: const Icon(Icons.play_arrow_rounded),
//               ),
//             if (header.shuffleEndpoint != null)
//               FilledButton.icon(
//                 onPressed: () async {
//                   // BottomSnackbar.showMessage(context, "Play starting");
//                   // await sl<MediaPlayer>().playYTFromEndpoint(
//                   //   header.shuffleEndpoint!,
//                   // );
//                 },
//                 label: const Text("Shuffle"),
//                 icon: const Icon(Icons.shuffle_rounded),
//               ),
//             if (header.radioEndpoint != null)
//               FilledButton.icon(
//                 onPressed: () async {
//                   // BottomSnackbar.showMessage(context, "Play starting");
//                   // await sl<MediaPlayer>().playYTFromEndpoint(
//                   //   header.radioEndpoint!,
//                   // );
//                 },
//                 label: const Text("Radio"),
//                 icon: const Icon(Icons.radar_outlined),
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return context.isWideScreen
//         ? Row(children: _drawItems(context))
//         : Column(children: _drawItems(context));
//   }
// }
