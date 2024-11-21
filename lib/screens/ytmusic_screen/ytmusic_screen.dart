// import 'package:flutter/material.dart';

// import '../../generated/l10n.dart';
// import '../../utils/adaptive_widgets/adaptive_widgets.dart';
// import 'albums_screen.dart';
// import 'artists_screen.dart';
// import 'playlists_screen.dart';
// import 'songs_screen.dart';
// import 'subscriptions_screen.dart';
// import 'youtube_history.dart';

// class YTMScreen extends StatefulWidget {
//   const YTMScreen({super.key});

//   @override
//   State<YTMScreen> createState() => _YTMScreenState();
// }

// class _YTMScreenState extends State<YTMScreen> with TickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: AdaptiveScaffold(
//         appBar: AdaptiveAppBar(
//           title: Text(S.of(context).YTMusic),
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//           actions: [
//             AdaptiveIconButton(
//                 icon: const Icon(
//                   Icons.history,
//                   size: 25,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     AdaptivePageRoute.create(
//                         (context) => const YoutubeHistory()),
//                   );
//                 })
//           ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(48),
//             child: Material(
//               color: Colors.transparent,
//               elevation: 0,
//               child: TabBar(
//                 labelColor: AdaptiveTheme.of(context).primaryColor,
//                 labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                 unselectedLabelStyle:
//                     const TextStyle(fontWeight: FontWeight.normal),
//                 isScrollable: true,
//                 tabs: [
//                   Tab(text: S.of(context).Songs),
//                   Tab(text: S.of(context).Albums),
//                   Tab(text: S.of(context).Playlists),
//                   Tab(text: S.of(context).Artists),
//                   Tab(text: S.of(context).Subscriptions)
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             SongsScreen(),
//             AlbumsScreen(),
//             PlaylistsScreen(),
//             ArtistsScreen(),
//             SubscriptionsScreen()
//           ],
//         ),
//       ),
//     );
//   }
// }
