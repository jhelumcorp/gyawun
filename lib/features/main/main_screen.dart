import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/features/home/home_screen.dart';
import 'package:gyawun_music/features/library/library_screen.dart';
import 'package:gyawun_music/features/search/search_screen.dart';
import 'package:gyawun_music/features/settings/settings_screen.dart';
import 'package:navigation_rail_m3e/navigation_rail_m3e.dart';

final destinations = [
  const NavigationDestination(
    icon: Icon(FluentIcons.home_24_regular),
    selectedIcon: Icon(FluentIcons.home_24_filled),
    label: 'Home',
  ),
  const NavigationDestination(
    icon: Icon(FluentIcons.search_24_regular),
    selectedIcon: Icon(FluentIcons.search_24_filled),
    label: 'Search',
  ),
  const NavigationDestination(
    icon: Icon(FluentIcons.book_24_regular),
    selectedIcon: Icon(FluentIcons.book_24_filled),
    label: 'Library',
  ),
  const NavigationDestination(
    icon: Icon(FluentIcons.settings_24_regular),
    selectedIcon: Icon(FluentIcons.settings_24_filled),
    label: 'Settings',
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onChanged(int value) {
    // Unfocus any text fields before changing pages
    FocusScope.of(context).unfocus();
    controller.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWideScreen = screenWidth >= 600;

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            CustomNavigationRail(
              onChanged: onChanged,
              selectedIndex: selectedIndex,
            ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                // Unfocus when swiping between pages
                FocusScope.of(context).unfocus();
                setState(() {
                  selectedIndex = value;
                });
              },
              children: const [
                HomeScreen(),
                SearchScreen(),
                LibraryScreen(),
                SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : NavigationBar(
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: selectedIndex,
              onDestinationSelected: onChanged,
              destinations: destinations,
            ),
    );
  }
}

class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final void Function(int index) onChanged;

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
          child: NavigationRailM3E(
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.onChanged,
            type: NavigationRailM3EType.alwaysExpand,
            modality: NavigationRailM3EModality.standard,
            sections: [
              NavigationRailM3ESection(
                destinations: destinations
                    .map(
                      (destination) => NavigationRailM3EDestination(
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                        label: destination.label,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
