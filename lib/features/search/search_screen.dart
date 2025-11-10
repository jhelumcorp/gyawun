import 'package:flutter/material.dart';
import 'package:gyawun_music/features/services/yt_music/search/yt_search_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(body: YTSearchScreen());
  }

  @override
  bool get wantKeepAlive => true;
}
