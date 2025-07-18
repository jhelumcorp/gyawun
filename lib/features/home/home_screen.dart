import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_exxtensions.dart';
import 'package:gyawun_music/features/providers/yt_music/home/yt_home_screen.dart';
import 'package:yaru/widgets.dart';
import 'package:yaru/yaru.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(title: Text("Home"))
          : AppBar(title: Text("Home")),
      body: YtHomeScreen(),
    );
  }
}
