import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/song_tile.dart';

import '../../services/yt_account.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../ytmusic/ytmusic.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen>
    with AutomaticKeepAliveClientMixin<AlbumsScreen> {
  List items = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // setState(() {
    //   loading=true;
    // });
    List data = await GetIt.I<YTMusic>().getLibraryAlbums();
    if (mounted) {
      setState(() {
        items = data;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AdaptiveScaffold(
      body: ValueListenableBuilder(
        valueListenable: GetIt.I<YTAccount>().isLogged,
        builder: (context, value, child) {
          if (value) {
            return Center(
              child: loading
                  ? const AdaptiveProgressRing()
                  : RefreshIndicator(
                      onRefresh: () => fetchData(),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          children: [
                            ...items.indexed.map((indexedItem) {
                              return YTMSongTile(
                                  items: items, index: indexedItem.$1);
                            }),
                          ],
                        ),
                      ),
                    ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
