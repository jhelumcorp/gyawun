import 'package:flutter/material.dart';
import 'package:vibe_music/data/home1.dart';
import 'package:vibe_music/generated/l10n.dart';
import 'package:vibe_music/utils/colors.dart';

class SearchSuggestions extends StatefulWidget {
  const SearchSuggestions({this.query = "", super.key});
  final String query;

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  TextEditingController textEditingController = TextEditingController();
  List suggestions = [];

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.query;
  }

  getSuggestions() async {
    HomeApi()
        .getSearchSuggestions(query: textEditingController.text)
        .then((value) {
      setState(() {
        suggestions = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
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
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          String e = suggestions[index];
          return ListTile(
            title: Text(e),
            onTap: () {
              Navigator.pop(context, e);
            },
          );
        },
        separatorBuilder: (context, index) =>
            Container(height: 0.5, color: grayColor),
      ),
    );
  }
}
