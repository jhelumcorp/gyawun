import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/screens/ytmusic_screen/song_tile.dart';
import 'package:gyawun_beta/ytmusic/ytmusic.dart';

import '../../utils/adaptive_widgets/adaptive_widgets.dart';

class BrowseSongsScreen extends StatefulWidget {
  const BrowseSongsScreen({required this.endpoint, super.key});
  final Map<String, dynamic> endpoint;

  @override
  State<BrowseSongsScreen> createState() => _BrowseSongsScreenState();
}

class _BrowseSongsScreenState extends State<BrowseSongsScreen> {
  late ScrollController _scrollController;
  YTMusic ytMusic = GetIt.I<YTMusic>();
  bool initialLoading = false;
  bool nextLoading = false;
  late List<Map<String, dynamic>> items = [];
  String? continuation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData();
  }

  @override
  void didUpdateWidget(covariant BrowseSongsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endpoint['browseId'] != widget.endpoint['browseId']) {
      fetchData();
    }
  }

  fetchData() async {
    setState(() {
      initialLoading = true;
      nextLoading = false;
    });
    Map<String, dynamic> response =
        await ytMusic.browse(body: widget.endpoint, limit: 2);
    if (mounted) {
      setState(() {
        initialLoading = false;
        nextLoading = false;
        List sections = response['sections'];
        for (var section in sections) {
          items.addAll(section['contents'].cast<Map<String, dynamic>>());
        }
        continuation = response['continuation'];
      });
    }
  }

  fetchNext() async {
    if (continuation == null) return;
    setState(() {
      nextLoading = true;
    });
    Map<String, dynamic> home =
        await ytMusic.browseContinuation(additionalParams: continuation!);
    List<Map<String, dynamic>>? secs =
        home['sections']?.cast<Map<String, dynamic>>();

    for (var section in secs ?? []) {
      items.addAll(section['contents']);
    }

    if (mounted) {
      setState(() {
        continuation = home['continuation'];
        nextLoading = false;
      });
    }
  }

  _scrollListener() async {
    if (initialLoading || nextLoading || continuation == null) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await fetchNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(),
      body: initialLoading
          ? const Center(child: AdaptiveProgressRing())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      ...items.indexed.map((indexedItem) {
                        return YTMSongTile(items: items, index: indexedItem.$1);
                      }),
                      if (!nextLoading && continuation != null)
                        const SizedBox(height: 64),
                      if (nextLoading)
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AdaptiveProgressRing()),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
