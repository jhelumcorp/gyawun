import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/api/api.dart';
import 'package:gyawun/api/extensions.dart';
import 'package:gyawun/api/ytmusic.dart';
import 'package:gyawun/components/search_tile.dart';
import 'package:gyawun/generated/l10n.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/enums.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainSearchScreen extends StatefulWidget {
  const MainSearchScreen({super.key});

  @override
  State<MainSearchScreen> createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen>
    with AutomaticKeepAliveClientMixin<MainSearchScreen> {
  bool searching = false;
  bool typing = true;
  Map items = {};
  List<String> hints = [];
  final TextEditingController _searchController = TextEditingController();
  SearchProvider searchProvider =
      Hive.box('settings').get('searchProvider', defaultValue: 'saavn') ==
              'youtube'
          ? SearchProvider.youtube
          : SearchProvider.saavn;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Hero(
          tag: "SearchField",
          child: TextField(
            autofocus: true,
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: darkGreyColor.withAlpha(50),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
              hintText: S().searchGyawun,
              prefixIcon: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
              suffixIcon: _searchController.text.trim().isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.text = "";

                        setState(() {});
                      },
                      child: const Icon(EvaIcons.close),
                    )
                  : null,
            ),
            onChanged: (value) => getHints(value),
            onSubmitted: (value) => searchItems(value),
            textInputAction: TextInputAction.search,
            maxLines: 1,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(S().searchProvider, style: textStyle(context)),
              trailing: DropdownButton2(
                underline: const SizedBox.shrink(),
                value: searchProvider,
                items: const [
                  DropdownMenuItem(
                      value: SearchProvider.saavn, child: Text("Saavn")),
                  DropdownMenuItem(
                      value: SearchProvider.youtube,
                      child: Text("Youtube Music"))
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      searchProvider = value;
                    });
                    searchItems(_searchController.text);
                  }
                },
              ),
            ),
            Expanded(
              child: _searchController.text.isEmpty
                  ? ListView(
                      children: Hive.box('searchHistory')
                          .keys
                          .toList()
                          .reversed
                          .map((key) {
                      String value = Hive.box('searchHistory').get(key);
                      return ListTile(
                        title: Text(value),
                        leading: const Icon(Icons.restore),
                        trailing: IconButton(
                            onPressed: () {
                              Hive.box('searchHistory').delete(key);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete_outline_rounded)),
                        onTap: () {
                          _searchController.text = value;
                          searchItems(value);
                        },
                      );
                    }).toList())
                  : typing
                      ? ListView(
                          children: hints
                              .map((e) => ListTile(
                                    title: Text(e),
                                    leading:
                                        const Icon(Icons.arrow_outward_rounded),
                                    onTap: () {
                                      _searchController.text = e;
                                      searchItems(e);
                                    },
                                  ))
                              .toList(),
                        )
                      : searching
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: items
                                    .map((key, val) {
                                      return MapEntry(
                                          key,
                                          (key == 'Episodes' ||
                                                  key == 'Podcasts')
                                              ? const SizedBox()
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      key,
                                                      style: textStyle(context)
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ),
                                                    ...val.map((item) {
                                                      return SearchTile(
                                                          item: item);
                                                    }).toList(),
                                                  ],
                                                ));
                                    })
                                    .values
                                    .toList(),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  getHints(query) async {
    setState(() {
      typing = true;
    });
    hints = await YtMusicService().getSearchSuggestions(query: query);
    setState(() {});
  }

  searchItems(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      searching = true;
      typing = false;
    });
    if (Hive.box('settings').get('searchHistory', defaultValue: true)) {
      Hive.box('searchHistory').add(query);
    }
    if (searchProvider == SearchProvider.saavn) {
      await searchSaavn(query);
    } else {
      await searchYoutube(query);
    }
    setState(() {
      searching = false;
    });
  }

  searchSaavn(String query) async {
    Map<dynamic, dynamic> songSearchResults =
        await SaavnAPI().fetchSongSearchResults(searchQuery: query, count: 5);
    List<Map<dynamic, dynamic>> searchResults =
        await SaavnAPI().fetchSearchResults(query);
    Map<dynamic, dynamic> results = {
      'Songs': songSearchResults['songs'],
      ...searchResults[0],
    };
    Map newResults = {};
    for (String key in sections) {
      if (results[key] != null) {
        newResults[key] = results[key];
      }
    }

    items = newResults;
  }

  searchYoutube(String query) async {
    items = {};
    List<Map<dynamic, dynamic>> res = await YtMusicService().search(query);

    Map results = {};
    for (var element in res) {
      List l = element['items'];
      if (l.any((element) => element['type'] == 'profile')) continue;
      results[element['title'].toString().capitalize()] = l;
    }
    // pprint(res);
    items = results;
  }

  @override
  bool get wantKeepAlive => true;
}

List<String> sections = [
  'Top Result',
  'Songs',
  'Videos',
  'Playlists',
  'Albums',
  'Artists',
  'Featured playlists',
  'Community playlists',
];
