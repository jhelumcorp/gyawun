import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/SearchScreens/PlaylistSearch.dart';
import 'package:vibe_music/screens/SearchScreens/SongsSearch.dart';
import 'package:vibe_music/utils/colors.dart';
import 'package:we_slide/we_slide.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {this.searchQuery = "", required this.weSlideController, super.key});
  final String searchQuery;
  final WeSlideController? weSlideController;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  // TabController? tabController;
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
    // tabController = TabController(length: 1,vsync: this);
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
    HomeApi.getSearch(textEditingController.text).then((Map value) {
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
    Track? song = context.watch<MusicPlayer>().song;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextField(
            decoration: const InputDecoration(
                hintText: "Enter a name",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
            textInputAction: TextInputAction.search,
            autofocus: true,
            onSubmitted: (value) {
              search();
            },
            // onChanged: (value) {
            //   setState(() {
            //     query = textEditingController.text;
            //   });
            // },
            controller: textEditingController,
          ),
        ),
        body: Column(
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
                      ? song?.colorPalette?.lightVibrantColor?.color ??
                          tertiaryColor
                      : Colors.transparent,
                  child: const Text("Songs"),
                  onPressed: () {
                    setState(() {
                      _pageIndex = 0;
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    });
                  },
                ),
                // MaterialButton(
                //   elevation: 0,
                //   focusElevation: 0,
                //   hoverElevation: 0,
                //   disabledElevation: 0,
                //   highlightElevation: 0,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20)),
                //   color: _pageIndex == 1
                //       ? song?.colorPalette?.lightVibrantColor?.color ??
                //           tertiaryColor
                //       : Colors.transparent,
                //   child: const Text("Artists"),
                //   onPressed: () {
                //     setState(() {
                //       _pageIndex = 1;
                //       pageController.animateToPage(1,
                //           duration: const Duration(milliseconds: 200),
                //           curve: Curves.easeIn);
                //     });
                //   },
                // ),
                MaterialButton(
                  elevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  highlightElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: _pageIndex == 1
                      ? song?.colorPalette?.lightVibrantColor?.color ??
                          tertiaryColor
                      : Colors.transparent,
                  child: const Text("Playlists"),
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
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : PageView(
                      onPageChanged: (value) {
                        setState(() {
                          _pageIndex = value;
                        });
                      },
                      controller: pageController,
                      children: [
                        SongsSearch(
                            songs: songs,
                            weSlideController: widget.weSlideController),
                        // ArtistsScreen(artists: artists),
                        PlaylistSearch(playlists: playlists)
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
