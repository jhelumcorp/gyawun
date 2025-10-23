import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final destinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',

    // tooltip: AppLocalizations.of(context)?.homeScreen ?? 'Home Screen',
  ),
  NavigationDestination(
    icon: Icon(Icons.search_outlined),
    selectedIcon: Icon(Icons.search),
    label: 'Search',

    // tooltip: AppLocalizations.of(context)?.search ?? 'Search Screen',
  ),
  NavigationDestination(
    icon: Icon(Icons.my_library_music_outlined),
    selectedIcon: Icon(Icons.library_music_sharp),
    label: 'Library',

    // tooltip: AppLocalizations.of(context)?.search ?? 'Library Screen',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    label: 'Settings',

    // tooltip: AppLocalizations.of(context)?.settings ?? 'Settings Screen',
  ),
];

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  Widget _buildNavigationRail(BuildContext context, bool extended) {
    return Column(
      children: [
        SizedBox(
          width: 255,
          child: AppBar(title: Text("Gyawun"), centerTitle: true),
        ),
        Expanded(
          child: NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,

            minExtendedWidth: 255,
            useIndicator: true,
            extended: extended,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            selectedLabelTextStyle: Theme.of(context).textTheme.headlineSmall,
            unselectedLabelTextStyle: Theme.of(context).textTheme.bodyLarge,
            destinations: destinations.map((destination) {
              return NavigationRailDestination(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                label: Text(destination.label),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWideScreen = screenWidth >= 600;
    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen) _buildNavigationRail(context, true),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: destinations,
            ),
    );
  }
}
