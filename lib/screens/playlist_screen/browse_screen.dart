import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../services/bottom_message.dart';
import '../../services/library.dart';
import '../../services/media_player.dart';
import '../../themes/colors.dart';
import '../../utils/bottom_modals.dart';
import '../../ytmusic/ytmusic.dart';
import '../home_screen/section_item.dart';
import '../../utils/extensions.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({required this.endpoint, this.isMore = false, super.key});
  final Map<String, dynamic> endpoint;
  final bool isMore;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late ScrollController _scrollController;
  YTMusic ytMusic = GetIt.I<YTMusic>();
  bool initialLoading = false;
  bool nextLoading = false;
  late Map header = {};
  late List<Map<String, dynamic>> sections = [];
  String? continuation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData();
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
        header = response['header'] ?? {};
        sections = response['sections'];
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
    if (mounted) {
      setState(() {
        sections.addAll(secs ?? []);
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
    return Scaffold(
      appBar: AppBar(
        title: header['title'] != null ? Text(header['title']) : null,
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: SafeArea(
                  child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HeaderWidget(
                        header: {'endpoint': widget.endpoint, ...header}),
                    ...sections.indexed.map((sec) {
                      return SectionItem(
                          section: sec.$2,
                          isMore: widget.isMore ||
                              sections.length == 1 ||
                              sec.$1 == 0);
                    }),
                    const SizedBox(height: 8),
                    if (nextLoading) const CircularProgressIndicator(),
                  ],
                ),
              )),
            ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    super.key,
    required this.header,
  });

  final Map<String, dynamic> header;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late bool isAddedToLibrary;

  @override
  initState() {
    super.initState();
  }

  _buildImage(List thumbnails, double maxWidth, {bool isRound = false}) {
    Map thumbnail = thumbnails.where((el) => el['width'] > 190).first;
    return ClipRRect(
        borderRadius: BorderRadius.circular(
            isRound ? min((thumbnail['height'] as int), 250).toDouble() : 8),
        child: CachedNetworkImage(
          imageUrl: thumbnail['url'].replaceAll('w540-h225', 'w225-h225'),
          width: min((thumbnail['height'] as int), 250).toDouble(),
          height: min((thumbnail['height'] as int), 250).toDouble(),
        ));
  }

  _buildContent(Map header, BuildContext context, {bool isRow = false}) {
    if (widget.header['playlistId'] != null) {
      isAddedToLibrary = context
              .watch<LibraryService>()
              .getPlaylist(widget.header['playlistId']) !=
          null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isRow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment:
            isRow ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (header['subtitle'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(header['subtitle'] ?? '', maxLines: 2),
            ),
          if (header['secondSubtitle'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(header['secondSubtitle']),
            ),
          if (header['description'] != null)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ExpandableText(
                  header['description'].split('\n')[0],
                  expandText: 'Show More',
                  collapseText: 'Show Less',
                  maxLines: isRow ? 3 : 2,
                  style: TextStyle(color: context.subtitleColor),
                )),
          if (header['playlistId'] != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                MaterialButton(
                  shape: const CircleBorder(),
                  color: greyColor,
                  padding: const EdgeInsets.all(14),
                  onPressed: () => context
                      .read<LibraryService>()
                      .addToOrRemoveFromLibrary(header)
                      .then((String message) {
                    BottomMessage.showText(context, message);
                  }),
                  child: Icon(isAddedToLibrary
                      ? Icons.library_add_check
                      : Icons.library_add),
                ),
                if (header['videoId'] != null || header['playlistId'] != null)
                  MaterialButton(
                    onPressed: () async {
                      await GetIt.I<MediaPlayer>()
                          .startPlaylistSongs(Map.from(header));
                    },
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    child: Icon(
                      Icons.play_arrow_outlined,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 32,
                    ),
                  ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: greyColor,
                  padding: const EdgeInsets.all(14),
                  onPressed: () {
                    Modals.showPlaylistBottomModal(context, header);
                  },
                  child: const Icon(
                    Icons.more_vert_outlined,
                    size: 20,
                  ),
                )
                // if (header['shiffleId'] != null)
                //   OutlinedButton(
                //     onPressed: () {},
                //     child: const Text('SHUFFLE'),
                //   ),
                // if (header['mixId'] != null)
                //   OutlinedButton(
                //     onPressed: () {},
                //     child: const Text('MIX'),
                //   ),
              ],
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth > 600
            ? Row(
                children: [
                  if (widget.header['thumbnails'] != null)
                    _buildImage(
                        widget.header['thumbnails'], constraints.maxWidth,
                        isRound: widget.header['type'] == 'ARTIST'),
                  const SizedBox(width: 4),
                  Expanded(
                      child:
                          _buildContent(widget.header, context, isRow: true)),
                ],
              )
            : Column(
                children: [
                  if (widget.header['thumbnails'] != null)
                    _buildImage(
                        widget.header['thumbnails'], constraints.maxWidth,
                        isRound: widget.header['type'] == 'ARTIST'),
                  SizedBox(height: widget.header['thumbnails'] != null ? 4 : 0),
                  _buildContent(widget.header, context),
                ],
              );
      }),
    );
  }
}
