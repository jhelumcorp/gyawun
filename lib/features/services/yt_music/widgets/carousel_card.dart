// import 'package:flutter/material.dart';
// import 'package:ytmusic/mixins/mixins.dart';
// import 'package:ytmusic/models/models.dart';

// class CarouselCard extends StatelessWidget {
//   const CarouselCard({super.key, required this.item});
//   final YTItem item;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Background Image
//             if (item is HasThumbnail)
//               Image.network(
//                 (item as HasThumbnail).thumbnails.last.url,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey.shade300,
//                     child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//                   );
//                 },
//               ),
//             // Dark gradient overlay for better text readability
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withValues(alpha: 0.5),
//                     Colors.black.withValues(alpha: 0.8),
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                 ),
//               ),
//             ),
//             // Text Content
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text('${item.title} tapped!')));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.title,
//                         maxLines: 1,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           shadows: [
//                             Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
//                           ],
//                         ),
//                       ),
//                       if (item.subtitle.isNotEmpty) const SizedBox(height: 8),
//                       if (item.subtitle.isNotEmpty)
//                         Text(
//                           item.subtitle,
//                           maxLines: 1,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 3),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CarouselItem {
//   const CarouselItem({required this.title, required this.subtitle, required this.imageUrl});
//   final String title;
//   final String subtitle;
//   final String imageUrl;
// }
