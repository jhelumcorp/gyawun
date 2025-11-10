// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gyawun_music/features/player/widgets/bottom_player.dart';
// import 'package:navigation_rail_m3e/navigation_rail_m3e.dart';

// // Import the router keys
// import '../../router.dart'
//     show
//         bottomSheetCounter,
//         homeNavigatorKey,
//         libraryNavigatorKey,
//         rootNavigatorKey,
//         searchNavigatorKey,
//         settingsNavigatorKey;

// final destinations = [
//   NavigationDestination(
//     icon: Icon(FluentIcons.home_24_regular),
//     selectedIcon: Icon(FluentIcons.home_24_filled),
//     label: 'Home',
//   ),
//   NavigationDestination(
//     icon: Icon(FluentIcons.search_24_regular),
//     selectedIcon: Icon(FluentIcons.search_24_filled),
//     label: 'Search',
//   ),
//   NavigationDestination(
//     icon: Icon(FluentIcons.book_24_regular),
//     selectedIcon: Icon(FluentIcons.book_24_filled),
//     label: 'Library',
//   ),
//   NavigationDestination(
//     icon: Icon(FluentIcons.settings_24_regular),
//     selectedIcon: Icon(FluentIcons.settings_24_filled),
//     label: 'Settings',
//   ),
// ];

// class MainScreen extends StatefulWidget {
//   final StatefulNavigationShell navigationShell;
//   const MainScreen({super.key, required this.navigationShell});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   List<GlobalKey<NavigatorState>> get _branchKeys => [
//     homeNavigatorKey,
//     searchNavigatorKey,
//     libraryNavigatorKey,
//     settingsNavigatorKey,
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final isWideScreen = screenWidth >= 600;

//     return PopScope(
//       canPop: false,

//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return; // Ignore if pop was already handled by system

//         final currentIndex = widget.navigationShell.currentIndex;
//         final currentKey = _branchKeys[currentIndex];
//         final currentNavigator = currentKey.currentState;

//         // 1. **CRITICAL FIX: Check and Pop Nested Page FIRST**
//         // If the current tab's navigator can pop, perform the pop and return.
//         if (currentNavigator != null && currentNavigator.canPop()) {
//           currentNavigator.pop();
//           return; // Event consumed: nested page was popped.
//         }

//         // 3. Check for other Modal Bottom Sheets on the Root Navigator
//         if (bottomSheetCounter.value > 0) {
//           Navigator.pop(rootNavigatorKey.currentContext!);
//           bottomSheetCounter.value--;
//           return; // Event consumed: modal sheet was popped.
//         }

//         // 4. Final Fallback: Exit App/Pop Shell
//         // If we reach here, we are at the root of a tab.
//         if (context.mounted) {
//           context.pop(); // Pop the shell route.
//         }
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Row(
//               children: [
//                 if (isWideScreen)
//                   CustomNavigationRail(navigationShell: widget.navigationShell),
//                 Expanded(child: widget.navigationShell),
//               ],
//             ),
//             BottomPlayer(),
//           ],
//         ),
//         bottomNavigationBar: isWideScreen
//             ? null
//             : NavigationBar(
//                 labelBehavior:
//                     NavigationDestinationLabelBehavior.onlyShowSelected,
//                 selectedIndex: widget.navigationShell.currentIndex,
//                 onDestinationSelected: widget.navigationShell.goBranch,
//                 destinations: destinations,
//               ),
//       ),
//     );
//   }
// }

// class CustomNavigationRail extends StatefulWidget {
//   const CustomNavigationRail({super.key, required this.navigationShell});

//   final StatefulNavigationShell navigationShell;

//   @override
//   State<CustomNavigationRail> createState() => _CustomNavigationRailState();
// }

// class _CustomNavigationRailState extends State<CustomNavigationRail> {
//   bool extended = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: 255,
//           child: AppBar(title: const Text("Gyawun"), centerTitle: true),
//         ),
//         Expanded(
//           child: NavigationRailM3E(
//             selectedIndex: widget.navigationShell.currentIndex,
//             onDestinationSelected: widget.navigationShell.goBranch,
//             type: NavigationRailM3EType.alwaysExpand,
//             modality: NavigationRailM3EModality.standard,
//             sections: [
//               NavigationRailM3ESection(
//                 destinations: destinations
//                     .map(
//                       (destination) => NavigationRailM3EDestination(
//                         icon: destination.icon,
//                         selectedIcon: destination.selectedIcon,
//                         label: destination.label,
//                       ),
//                     )
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
