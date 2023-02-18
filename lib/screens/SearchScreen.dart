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
import 'package:vibe_music/screens/SearchScreens/videoSearch.dart';
import 'package:vibe_music/utils/navigator.dart';
import 'package:vibe_music/widgets/search_history.dart';

import '../data/YTMusic/ytmusic.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen>, TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  TabController? tabController;
  bool loading = false;
  bool submitted = false;
  List songs = [];
  List artists = [];
  List playlists = [];
  List suggestions = [];
  List albums = [];

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    tabController = TabController(
      length: 5,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  search(value) {
    focusNode.unfocus();
    if (value != null) {
      setState(() {
        submitted = true;
      });
      context.read<SearchProvider>().refresh();
      textEditingController.text = value;
      Box box = Hive.box('search_history');
      int index = box.values.toList().indexOf(textEditingController.text);
      if (index != -1) {
        box.deleteAt(index);
      }
      box.add(textEditingController.text);
    }
    setState(() {});
  }

  getSuggestions() async {
    if (mounted) {
      setState(() {
        submitted = false;
      });

      YTMUSIC.suggestions(textEditingController.text).then((value) {
        if (mounted) {
          setState(() {
            suggestions = value;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: darkTheme ? Colors.white : Colors.black,
            ),
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
              focusNode: focusNode,
              style: Theme.of(context).primaryTextTheme.titleLarge,
              decoration: InputDecoration(
                  hintText: S.of(context).Search_something,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
              textInputAction: TextInputAction.search,
              onChanged: (text) {
                getSuggestions();
              },
              onSubmitted: (text) {
                search(text);
              },
              controller: textEditingController,
            ),
          ),
          body: Column(
            children: [
              if (textEditingController.text.trim().isNotEmpty && submitted)
                Material(
                  child: TabBar(
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
                          child: Text(
                            S.of(context).Songs,
                            style: tabController?.index == 0
                                ? Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!
                                : TextStyle(
                                    color: darkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
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
                          child: Text(
                            S.of(context).Videos,
                            style: tabController?.index == 1
                                ? Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                : TextStyle(
                                    color: darkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
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
                          child: Text(
                            S.of(context).Artists,
                            style: tabController?.index == 2
                                ? Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                : TextStyle(
                                    color: darkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
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
                          child: Text(
                            S.of(context).Albums,
                            style: tabController?.index == 3
                                ? Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                : TextStyle(
                                    color: darkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: tabController?.index == 4
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            S.of(context).Playlists,
                            style: tabController?.index == 4
                                ? Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                : TextStyle(
                                    color: darkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: textEditingController.text.trim().isEmpty
                    ? SearchHistory(
                        onTap: (value) {
                          search(value);
                        },
                        onTrailing: (e) {
                          setState(() {
                            textEditingController.text = e;
                            submitted = false;
                          });
                        },
                      )
                    : submitted
                        ? Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    SongsSearch(
                                        query: textEditingController.text),
                                    VideoSearch(
                                        query: textEditingController.text),
                                    ArtistsSearch(
                                        query: textEditingController.text),
                                    AlbumSearch(
                                        query: textEditingController.text),
                                    PlaylistSearch(
                                        query: textEditingController.text)
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ValueListenableBuilder(
                            valueListenable: Hive.box('settings').listenable(),
                            builder: (context, Box box, child) {
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  String e = suggestions[index];
                                  return ListTile(
                                    enableFeedback: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    visualDensity: VisualDensity.compact,
                                    leading: Icon(Icons.search,
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyLarge
                                            ?.color),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          textEditingController.text = e;
                                          submitted = false;
                                        });
                                      },
                                      icon: Icon(
                                          box.get('textDirection',
                                                      defaultValue: 'ltr') ==
                                                  'rtl'
                                              ? CupertinoIcons.arrow_up_right
                                              : CupertinoIcons.arrow_up_left,
                                          color: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyLarge
                                              ?.color),
                                    ),
                                    dense: true,
                                    title: Text(
                                      e,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyLarge,
                                    ),
                                    onTap: () {
                                      search(e);
                                    },
                                  );
                                },
                              );
                            }),
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
