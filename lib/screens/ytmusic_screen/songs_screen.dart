// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import '../../utils/adaptive_widgets/adaptive_widgets.dart';
// import '../../ytmusic/ytmusic.dart';
// import 'song_tile.dart';

// class SongsScreen extends StatefulWidget {
//   const SongsScreen({super.key});

//   @override
//   State<SongsScreen> createState() => _SongsScreenState();
// }

// class _SongsScreenState extends State<SongsScreen>
//     with AutomaticKeepAliveClientMixin<SongsScreen> {
//   late ScrollController _scrollController;
//   List items = [];
//   bool initialLoading = true;
//   bool nextLoading = false;
//   String? continuation;
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);
//     fetchData();
//   }

//   _scrollListener() async {
//     if (initialLoading || nextLoading || continuation == null) {
//       return;
//     }

//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       await fetchNext();
//     }
//   }

//   Future<void> fetchData() async {
//     setState(() {
//       initialLoading = true;
//     });
//     Map data = await GetIt.I<YTMusic>().getLibrarySongs();
//     if (mounted) {
//       setState(() {
//         items = data['contents'];
//         continuation = data['continuation'];
//         initialLoading = false;
//       });
//     }
//   }

//   fetchNext() async {
//     if (continuation == null) return;
//     setState(() {
//       nextLoading = true;
//     });
//     Map data = await GetIt.I<YTMusic>()
//         .getLibrarySongs(continuationParams: continuation);
//     if (mounted) {
//       setState(() {
//         items.addAll(data['contents']);
//         continuation = data['continuation'];
//         nextLoading = false;
//       });
//     }
//     setState(() {
//       nextLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return AdaptiveScaffold(
//       body: initialLoading
//           ? const Center(child: AdaptiveProgressRing())
//           : RefreshIndicator(
//               onRefresh: () => fetchData(),
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Center(
//                   child: Container(
//                     constraints: const BoxConstraints(maxWidth: 1000),
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Column(
//                       children: [
//                         ...items.indexed.map((indexedItem) {
//                           return YTMSongTile(
//                               items: items, index: indexedItem.$1);
//                         }),
//                         if (!nextLoading && continuation != null)
//                           const SizedBox(height: 64),
//                         if (nextLoading)
//                           const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: AdaptiveProgressRing(),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
