import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:yaru/widgets.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              leading: Navigator.of(context).canPop() ? YaruBackButton() : null,
              title: Text("Library"),
            )
          : null,
    );
  }
}
