// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ytmusic/models/chip.dart';

// class ChipItem extends StatelessWidget {
//   const ChipItem({super.key, required this.chip});

//   final YTChip chip;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       shadowColor: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () {
//           context.push('/ytmusic/chip/${jsonEncode(chip.endpoint)}/${chip.title}');
//         },
//         child: Ink(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surfaceContainer,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             chip.title,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
