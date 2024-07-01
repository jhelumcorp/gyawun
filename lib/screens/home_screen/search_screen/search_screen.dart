import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: LayoutBuilder(builder: (context, constraints) {
          return AppBar(
            title: widget.endpoint != null
                ? Text(widget.endpoint!['query'])
                : Hero(
                    tag: "SearchField",
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: constraints.maxWidth > 400 ? 300 : null,
                        child: TypeAheadField(
                          suggestionsCallback: (query) =>
                              GetIt.I<YTMusic>().getSearchSuggestions(query),
                          builder: (context, controller, focusNode) {
                            _textEditingController = controller;
                            _focusNode = focusNode;
                            return TextField(
                              focusNode: _focusNode,
                              controller: _textEditingController,
                              onSubmitted: onSubmit,
                              onChanged: (value) {
                                getSuggestions(value);
                              },
                              decoration: InputDecoration(
                                  fillColor: darkGreyColor.withAlpha(100),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: S.of(context).searchGyawun,
                                  prefixIcon: constraints.maxWidth < 400
                                      ? IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.arrow_back))
                                      : null,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _textEditingController?.text = '';
                                        });
                                      },
                                      icon: const Icon(CupertinoIcons.clear))),
                            );
                          },
                          itemBuilder: (context, value) {
                            if (value['type'] == 'TEXT') {
                              return ListTile(
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
                    ),
                  ),
            automaticallyImplyLeading:
                (widget.endpoint == null && constraints.maxWidth <= 400)
                    ? false
                    : true,
          );
        }),
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ...results.map((section) {
                    return SearchSectionItem(
                        section: section, isMore: widget.isMore);
                  }),
                  if (nextLoading)
                    const Center(child: CircularProgressIndicator())
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
          ListTile(
            title: Text(
              section['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: section['trailing']?['text'] != null
                ? MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SearchScreen(
                                  endpoint: section['trailing']['endpoint'],
                                  isMore: true)));
                    },
                    child: Text(
                      section['trailing']['text'],
                      style: const TextStyle(fontSize: 12),
                    ))
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),
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
              CupertinoPageRoute(
                builder: (context) => BrowseScreen(endpoint: item['endpoint']),
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
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
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
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(
                ['ARTIST', 'PROFILE'].contains(item['type']) ? 30 : 3),
            child: Image.network(
              item['thumbnails'].first['url'],
              width: 40,
            )),
        trailing: item['videoId'] == null && item['endpoint'] != null
            ? const Icon(CupertinoIcons.chevron_right)
            : null,
      ),
    );
  }
}
