import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/api/api.dart';
import 'package:gyavun/api/format.dart';
import 'package:gyavun/components/home_section.dart';
import 'package:gyavun/components/recently_played.dart';
import 'package:gyavun/components/recomendations.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/utils/recomendations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  List songs = [];
  List recomendedSongs = [];
  double tileHeight = 0;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Hero(
          tag: "SearchField",
          child: TextField(
            onTap: () => context.go('/search'),
            readOnly: true,
            decoration: InputDecoration(
              fillColor: darkGreyColor.withAlpha(50),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
              hintText: 'Search Gyawun',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchAllData(),
        child: ListView(
          children: [
            if (recomendedSongs.isNotEmpty)
              Recomendations(recomendedSongs: recomendedSongs),
            const RecentlyPlayed(),
            ...songs.map((item) => HomeSection(item: item)).toList()
          ],
        ),
      ),
    );
  }

  fetchAllData() async {
    recomendedSongs = await getRecomendations();
    songs = await fetchHomeData();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

Future<List> fetchHomeData() async {
  Map<dynamic, dynamic> data = await SaavnAPI().fetchHomePageData();
  Map<dynamic, dynamic> formatedData =
      await FormatResponse.formatPromoLists(data);
  Map modules = formatedData['modules'];

  List tiles = [];
  modules.forEach((key, value) {
    tiles.add({
      'title': value['title'],
      'songs': formatedData[key],
    });
  });
  return tiles;
}
