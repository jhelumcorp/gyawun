import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/data/YTMusic/ytmusic.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:async/async.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/widgets/search_history.dart';

class SearchSuggestions extends StatefulWidget {
  const SearchSuggestions({this.query = "", super.key});
  final String query;

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  TextEditingController textEditingController = TextEditingController();
  CancelableOperation? cancelableOperation;
  List suggestions = [];

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.query;
    if (widget.query.isNotEmpty) getSuggestions();
  }

  getSuggestions() async {
    if (mounted) {
      setState(() {});

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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, child) {
          return Directionality(
            textDirection:
                box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,
                      color:
                          Theme.of(context).primaryTextTheme.bodyLarge?.color),
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
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: S.of(context).Search_something,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    getSuggestions();
                  },
                  onSubmitted: (value) {
                    Navigator.pop(context, value);
                  },
                  controller: textEditingController,
                ),
              ),
              body: textEditingController.text.trim().isEmpty
                  ? SearchHistory(
                      onTap: (e) {
                        Navigator.pop(context, e);
                      },
                      onTrailing: (e) {
                        textEditingController.text = e;
                        setState(() {});
                      },
                    )
                  : ListView.builder(
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
                          trailing: Icon(
                              box.get('textDirection', defaultValue: 'ltr') ==
                                      'rtl'
                                  ? CupertinoIcons.arrow_up_right
                                  : CupertinoIcons.arrow_up_left,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge
                                  ?.color),
                          dense: true,
                          title: Text(
                            e,
                            style: Theme.of(context).primaryTextTheme.bodyLarge,
                          ),
                          onTap: () {
                            Navigator.pop(context, e);
                          },
                        );
                      },
                    ),
            ),
          );
        });
  }
}
