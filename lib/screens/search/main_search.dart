import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gyavun/api/api.dart';
import 'package:gyavun/components/search_tile.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';

class MainSearchScreen extends StatefulWidget {
  const MainSearchScreen({super.key});

  @override
  State<MainSearchScreen> createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen>
    with AutomaticKeepAliveClientMixin<MainSearchScreen> {
  bool searching = false;
  Map items = {};
  List<String> hints = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SaavnAPI().getTopSearches().then((value) {
      setState(() {
        hints = value;
      });
    });
  }

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
              hintText: 'Search Gyavun',
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
            onChanged: (value) => searchItems(value),
            onSubmitted: (value) => searchItems(value),
            textInputAction: TextInputAction.search,
            maxLines: 1,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
      body: SafeArea(
        child: _searchController.text.trim().isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: hints
                      .map((e) => GestureDetector(
                            onTap: () {
                              _searchController.text = e;
                              searchItems(e);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: darkGreyColor.withAlpha(50),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(e),
                            ),
                          ))
                      .toList(),
                ),
              )
            : searching
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        if (items['Top Result'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Top Result",
                                style: textStyle(context).copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ...items['Top Result'].map((item) {
                                return SearchTile(item: item);
                              }).toList(),
                            ],
                          ),

                        // songs section
                        if (items['Songs'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Songs",
                                style: textStyle(context).copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ...items['Songs'].map((item) {
                                return SearchTile(item: item);
                              }).toList(),
                            ],
                          ),
                        // playlists section
                        if (items['Playlists'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Playlists",
                                style: textStyle(context).copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ...items['Playlists'].map((item) {
                                return SearchTile(item: item);
                              }).toList(),
                            ],
                          ),
                        if (items['Albums'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Albums",
                                style: textStyle(context).copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ...items['Albums'].map((item) {
                                return SearchTile(item: item);
                              }).toList(),
                            ],
                          ),
                        if (items['Artists'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Artists",
                                style: textStyle(context).copyWith(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ...items['Artists'].map((item) {
                                return SearchTile(item: item);
                              }).toList(),
                            ],
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  searchItems(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      searching = true;
    });
    Map<dynamic, dynamic> songSearchResults =
        await SaavnAPI().fetchSongSearchResults(searchQuery: query, count: 5);
    List<Map<dynamic, dynamic>> searchResults =
        await SaavnAPI().fetchSearchResults(query);
    Map<dynamic, dynamic> results = searchResults[0];
    results['Songs'] = songSearchResults['songs'];
    items = results;
    setState(() {
      searching = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
