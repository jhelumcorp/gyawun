import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/song_tile.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:gyawun_beta/ytmusic/ytmusic.dart';

import '../../../../services/yt_account.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen>
    with AutomaticKeepAliveClientMixin<PlaylistsScreen> {
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
    List data = await GetIt.I<YTMusic>().getLibraryPlaylists();
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
                          children: items.indexed.map((playlist) {
                            return YTMSongTile(
                              items: items,
                              index: playlist.$1,
                              mainBrowse: true,
                            );
                          }).toList(),
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
