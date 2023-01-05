import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/screens/SearchScreens/ArtistsSearch.dart';
import 'package:vibe_music/screens/SearchScreens/PlaylistSearch.dart';
import 'package:vibe_music/screens/SearchScreens/SongsSearch.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({this.searchQuery = "", super.key});
  final String searchQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  PageController pageController = PageController();
  int _pageIndex = 0;
  bool loading = false;
  String query = "";
  List songs = [];
  List artists = [];
  List playlists = [];
  @override
  void initState() {
    super.initState();
  }

  search() async {
    loading = true;
    setState(() {});
    HomeApi.getSearch(textEditingController.text).then((Map value) {
      setState(() {
        loading = false;
        songs = value['songs'];
        artists = value['artists'];
        playlists = value['playlists'];
        _pageIndex = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextField(
            style: Theme.of(context).primaryTextTheme.titleLarge,
            decoration: InputDecoration(
                hintText: S.of(context).Search_something,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              search();
            },
            controller: textEditingController,
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: _pageIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            child: Text(S.of(context).Songs,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis)),
                            onPressed: () {
                              setState(() {
                                _pageIndex = 0;
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: _pageIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            child: Text(
                              S.of(context).Artists,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            onPressed: () {
                              _pageIndex = 1;
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: _pageIndex == 2
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            child: Text(S.of(context).Playlists,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis)),
                            onPressed: () {
                              _pageIndex = 2;
                              pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: (value) {
                        setState(() {
                          _pageIndex = value;
                        });
                      },
                      controller: pageController,
                      children: [
                        SongsSearch(songs: songs),
                        ArtistsScreen(artists: artists),
                        PlaylistSearch(playlists: playlists)
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
