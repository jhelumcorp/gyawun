import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:gyawun_beta/utils/pprint.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import '../../../generated/l10n.dart';
import '../../../services/media_player.dart';
import '../../../themes/colors.dart';
import '../../../utils/bottom_modals.dart';
import '../../../ytmusic/ytmusic.dart';
import '../../browse_screen/browse_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({this.endpoint, this.isMore = false, super.key});
  final Map<String, dynamic>? endpoint;
  final bool isMore;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  TextEditingController? _textEditingController;
  FocusNode? _focusNode;
  bool initialLoading = false;
  bool nextLoading = false;
  List<Map<String, dynamic>> results = [];
  String? continuation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _focusNode?.requestFocus();
    if (widget.endpoint != null) {
      search(widget.endpoint!);
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

  onSubmit(String value) async {
    _focusNode?.unfocus();
    setState(() {
      initialLoading = true;
    });
    if (Hive.box('SETTINGS').get('SEARCH_HISTORY', defaultValue: true)) {
      await Hive.box('SEARCH_HISTORY').delete(value.toLowerCase());
      await Hive.box('SEARCH_HISTORY').put(value.toLowerCase(), value);
    }
    Map response = await GetIt.I<YTMusic>().search(value);
    results = response['sections'];
    continuation = response['continuation'];
    setState(() {
      initialLoading = false;
    });
  }

  fetchNext() async {
    if (continuation == null) return;
    setState(() {
      nextLoading = true;
    });
    Map response = await GetIt.I<YTMusic>()
        .search('', endpoint: widget.endpoint, additionalParams: continuation!);
    results.addAll(response['sections']);
    continuation = response['continuation'];
    if (mounted) {
      setState(() {
        nextLoading = false;
      });
    }
  }

  search(Map<String, dynamic> value, {String additionalParams = ''}) async {
    _textEditingController?.value = value['query'];
    setState(() {
      initialLoading = true;
    });
    Map response = await GetIt.I<YTMusic>()
        .search('', endpoint: value, additionalParams: additionalParams);
    results = response['sections'];
    continuation = response['continuation'];
    setState(() {
      initialLoading = false;
    });
  }

  getSuggestions(String query) async {
    await GetIt.I<YTMusic>().getSearchSuggestions(query);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: PreferredSize(
        preferredSize: const AdaptiveAppBar().preferredSize,
        child: LayoutBuilder(builder: (context, constraints) {
          pprint(constraints.maxWidth);
          return AdaptiveAppBar(
            title: widget.endpoint != null
                ? Text(widget.endpoint!['query'])
                : Hero(
                    tag: "SearchField",
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: TypeAheadField(
                              suggestionsCallback: (query) => GetIt.I<YTMusic>()
                                  .getSearchSuggestions(query),
                              builder: (context, controller, focusNode) {
                                _textEditingController = controller;
                                _focusNode = focusNode;
                                return AdaptiveTextField(
                                  focusNode: _focusNode,
                                  controller: _textEditingController,
                                  onSubmitted: onSubmit,
                                  onChanged: (value) {
                                    getSuggestions(value);
                                  },
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  autofocus: false,
                                  textInputAction: TextInputAction.search,
                                  fillColor: Platform.isWindows
                                      ? null
                                      : darkGreyColor.withAlpha(100),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  borderRadius: BorderRadius.circular(
                                      Platform.isWindows ? 4.0 : 35),
                                  hintText: S.of(context).searchGyawun,
                                  prefix: constraints.maxWidth > 400
                                      ? null
                                      : const AdaptiveBackButton(),
                                  suffix: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _textEditingController?.text = '';
                                      });
                                    },
                                    child: const Icon(CupertinoIcons.clear),
                                  ),
                                );
                              },
                              decorationBuilder: Platform.isWindows
                                  ? (context, child) {
                                      return Ink(
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          color: Platform.isWindows
                                              ? fluent_ui.FluentTheme.of(
                                                      context)
                                                  .inactiveBackgroundColor
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: child,
                                      );
                                    }
                                  : null,
                              itemBuilder: (context, value) {
                                if (value['type'] == 'TEXT') {
                                  return AdaptiveListTile(
                                      leading: value['isHistory'] != null
                                          ? const Icon(Icons.history)
                                          : null,
                                      title: Text(value['query']),
                                      onTap: () {
                                        setState(() {
                                          _textEditingController?.text =
                                              value['query'];
                                        });
                                        onSubmit(value['query']);
                                      });
                                }
                                return SearchListTile(item: value);
                              },
                              onSelected: (value) => (),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            automaticallyImplyLeading:
                (constraints.maxWidth <= 400) ? false : true,
          );
        }),
      ),
      body: initialLoading
          ? const Center(child: AdaptiveProgressRing())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ...results.map((section) {
                    if (Platform.isWindows) {
                      return Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          padding: const EdgeInsets.all(8.0),
                          child: fluent_ui.Card(
                            borderRadius: BorderRadius.circular(8),
                            child: SearchSectionItem(
                                section: section, isMore: widget.isMore),
                          ),
                        ),
                      );
                    }
                    return SearchSectionItem(
                        section: section, isMore: widget.isMore);
                  }),
                  if (nextLoading) const Center(child: AdaptiveProgressRing())
                ],
              ),
            ),
    );
  }
}

class SearchSectionItem extends StatelessWidget {
  const SearchSectionItem(
      {required this.section, this.isMore = false, super.key});
  final Map<String, dynamic> section;
  final bool isMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (section['title'] != null && !isMore)
          AdaptiveListTile(
            title: Text(
              section['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: section['trailing']?['text'] != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Platform.isAndroid ? 12 : 0),
                    child: AdaptiveOutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            AdaptivePageRoute.create(
                              (context) => SearchScreen(
                                  endpoint: section['trailing']['endpoint'],
                                  isMore: true),
                            ),
                          );
                        },
                        child: Text(
                          section['trailing']['text'],
                          style: const TextStyle(fontSize: 12),
                        )),
                  )
                : null,
          ),
        ...section['contents'].map((item) {
          // pprint(item);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SearchListTile(item: item),
          );
        })
      ],
    );
  }
}

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    required this.item,
    super.key,
  });
  final Map item;
  @override
  Widget build(BuildContext context) {
    return AdaptiveListTile(
      // borderRadius: BorderRadius.circular(5),
      onSecondaryTap: () {
        if (item['videoId'] != null) {
          Modals.showSongBottomModal(context, item);
        } else if (item['endpoint'] != null) {
          Modals.showPlaylistBottomModal(context, item);
        }
      },
      onTap: () async {
        if (item['videoId'] != null) {
          await GetIt.I<MediaPlayer>().playSong(Map.from(item));
        } else if (item['endpoint'] != null && item['videoId'] == null) {
          Navigator.push(
              context,
              AdaptivePageRoute.create(
                (context) => BrowseScreen(endpoint: item['endpoint']),
              ));
        }
      },
      onLongPress: () {
        if (item['videoId'] != null) {
          Modals.showSongBottomModal(context, item);
        } else if (item['endpoint'] != null) {
          Modals.showPlaylistBottomModal(context, item);
        }
      },
      dense: true,
      title: Text(
        item['title'],
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: item['subtitle'] != null
          ? Text(
              item['subtitle'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: item['thumbnails'] != null && item['thumbnails'].isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                  ['ARTIST', 'PROFILE'].contains(item['type']) ? 30 : 3),
              child: Image.network(
                item['thumbnails'].first['url'],
                width: 40,
              ))
          : null,
      trailing: item['videoId'] == null && item['endpoint'] != null
          ? const Icon(CupertinoIcons.chevron_right)
          : null,
    );
  }
}
