import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/providers/SearchProvider.dart';
import 'package:vibe_music/screens/SearchScreens/AlbumSearch.dart';
import 'package:vibe_music/screens/SearchScreens/ArtistsSearch.dart';
import 'package:vibe_music/screens/SearchScreens/PlaylistSearch.dart';
import 'package:vibe_music/screens/SearchScreens/SongsSearch.dart';
import 'package:vibe_music/screens/SearchScreens/SuggestionsSearch.dart';
import 'package:vibe_music/utils/navigator.dart';
import 'package:vibe_music/widgets/search_history.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({this.searchQuery = "", super.key});
  final String searchQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen>, TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  TabController? tabController;
  bool loading = false;
  List songs = [];
  List artists = [];
  List playlists = [];
  List suggestions = [];
  List albums = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.search_rounded),
            actions: textEditingController.text.trim().isNotEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          onPressed: () {
                            textEditingController.text = "";
                            setState(() {});
                          },
                          icon: Icon(
                            CupertinoIcons.xmark,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge
                                ?.color,
                          )),
                    )
                  ]
                : [],
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: TextField(
              onTap: () {
                mainNavigatorKey?.currentState
                    ?.push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SearchSuggestions(
                    query: textEditingController.text,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ))
                    .then((value) {
                  if (value != null) {
                    context.read<SearchProvider>().refresh();
                    textEditingController.text = value;
                    Box box = Hive.box('search_history');
                    int index =
                        box.values.toList().indexOf(textEditingController.text);
                    if (index != -1) {
                      box.deleteAt(index);
                    }
                    box.add(textEditingController.text);
                  }
                  setState(() {});
                });
              },
              style: Theme.of(context).primaryTextTheme.titleLarge,
              decoration: InputDecoration(
                  hintText: S.of(context).Search_something,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
              textInputAction: TextInputAction.search,
              enableInteractiveSelection: false,
              focusNode: AlwaysDisabledFocusNode(),
              controller: textEditingController,
            ),
            bottom: textEditingController.text.trim().isEmpty
                ? null
                : TabBar(
                    controller: tabController,
                    enableFeedback: false,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    indicator: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tabController?.index == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).Songs),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tabController?.index == 1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).Artists),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tabController?.index == 2
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).Albums),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tabController?.index == 3
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(S.of(context).Playlists),
                        ),
                      ),
                    ],
                  ),
          ),
          body: textEditingController.text.trim().isEmpty
              ? SearchHistory(
                  onTap: (value) {
                    if (value != null) {
                      textEditingController.text = value;
                    }
                    setState(() {});
                  },
                  onTrailing: (e) {
                    setState(() {
                      textEditingController.text = e;
                    });
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          SongsSearch(query: textEditingController.text),
                          ArtistsSearch(query: textEditingController.text),
                          AlbumSearch(query: textEditingController.text),
                          PlaylistSearch(query: textEditingController.text)
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
