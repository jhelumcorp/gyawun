import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/home/yt_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Home")),
      body: YTHomeScreen(),
    );
  }
}
