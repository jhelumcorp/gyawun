import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_exxtensions.dart';
import 'package:yaru/widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              leading: Navigator.of(context).canPop() ? YaruBackButton() : null,
              title: Text("Search"),
            )
          : AppBar(title: Text("Search")),
      body: Center(child: Text("Search")),
    );
  }
}
