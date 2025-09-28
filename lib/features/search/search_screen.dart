import 'package:flutter/material.dart';
import 'package:gyawun_music/features/providers/yt_music/search/yt_search_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YtSearchScreen(),
    );
  }
}
