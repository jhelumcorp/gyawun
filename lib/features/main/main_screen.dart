import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import the router keys
import '../../router.dart'
    show
        bottomSheetCounter,
        homeNavigatorKey,
        libraryNavigatorKey,
        rootNavigatorKey,
        searchNavigatorKey,
        settingsNavigatorKey;

final destinations = [
  NavigationDestination(
    icon: Icon(FluentIcons.home_24_regular),
    selectedIcon: Icon(FluentIcons.home_24_filled),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(FluentIcons.search_24_regular),
    selectedIcon: Icon(FluentIcons.search_24_filled),
    label: 'Search',
  ),
  NavigationDestination(
    icon: Icon(FluentIcons.book_24_regular),
    selectedIcon: Icon(FluentIcons.book_24_filled),
    label: 'Library',
  ),
  NavigationDestination(
    icon: Icon(FluentIcons.settings_24_regular),
    selectedIcon: Icon(FluentIcons.settings_24_filled),
    label: 'Settings',
  ),
];

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainScreen({super.key, required this.navigationShell});

  List<GlobalKey<NavigatorState>> get _branchKeys => [
    homeNavigatorKey,
    searchNavigatorKey,
    libraryNavigatorKey,
    settingsNavigatorKey,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWideScreen = screenWidth >= 600;

    return PopScope(
      canPop: false, // we’ll decide manually whether to pop or exit
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // already popped by inner navigator
        if (bottomSheetCounter.value > 0) {
          Navigator.pop(rootNavigatorKey.currentContext!);
          bottomSheetCounter.value--;
          return;
        }

        final currentIndex = navigationShell.currentIndex;
        final currentKey = _branchKeys[currentIndex];
        final currentNavigator = currentKey.currentState;

        // Try popping the current tab’s stack
        if (currentNavigator != null && await currentNavigator.maybePop()) {
          return; // popped successfully
        }

        // If nothing left to pop, exit app
        if (context.mounted) {
          final rootNavigator = Navigator.of(context);
          if (rootNavigator.canPop()) {
            rootNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            if (isWideScreen)
              CustomNavigationRail(navigationShell: navigationShell),
            Expanded(child: navigationShell),
          ],
        ),
        bottomNavigationBar: isWideScreen
            ? null
            : NavigationBar(
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: navigationShell.goBranch,
                destinations: destinations,
              ),
      ),
    );
  }
}

class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  bool extended = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 255,
          child: AppBar(title: const Text("Gyawun"), centerTitle: true),
        ),
        Expanded(
          child: NavigationRail(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: widget.navigationShell.goBranch,
            minExtendedWidth: 255,
            useIndicator: true,
            extended: extended,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            selectedLabelTextStyle: Theme.of(context).textTheme.titleLarge,
            unselectedLabelTextStyle: Theme.of(context).textTheme.bodyLarge,
            destinations: destinations
                .map(
                  (destination) => NavigationRailDestination(
                    icon: destination.icon,
                    selectedIcon: destination.selectedIcon,
                    label: Text(destination.label),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
