import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/features/main/main_desktop.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return MainDesktop(navigationShell: navigationShell);
  }
}
