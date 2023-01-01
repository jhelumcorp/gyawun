import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/SearchScreens/ArtistsScreen.dart';
import 'package:vibe_music/screens/SearchScreens/PlaylistSearch.dart';
import 'package:vibe_music/screens/SearchScreens/SongsSearch.dart';
import 'package:vibe_music/utils/colors.dart';

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

  fetchSongs() async {
    loading = true;
    HomeApi.getSongs(textEditingController.text).then((List value) {
      setState(() {
        loading = false;
        songs = value;
      });
    });
  }

  fetchArtists() async {
    HomeApi.getArtists(textEditingController.text).then((List value) {
      setState(() {
        loading = false;
        artists = value;
      });
    });
  }

  search() async {
    loading = true;
    setState(() {});
    HomeApi.getSearch(textEditingController.text).then((Map value) {
      log(value.toString());
      setState(() {
        loading = false;
        songs = value['songs'];
        artists = value['artists'];
        playlists = value['playlists'];
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
                hintText: S.of(context).EnterAName,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
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
                        child: Text(S.of(context).Songs),
                        onPressed: () {
                          setState(() {
                            _pageIndex = 0;
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                      MaterialButton(
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
                        child: Text("Artists"),
                        onPressed: () {
                          _pageIndex = 1;
                          pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                      ),
                      MaterialButton(
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
                        child: Text(S.of(context).Playlists),
                        onPressed: () {
                          _pageIndex = 1;
                          pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                      ),
                    ],
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
