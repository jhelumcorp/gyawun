import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  /// Creates a new [AdaptiveScaffold].
  const AdaptiveScaffold({this.body, this.appBar, super.key});

  /// The primary content of the [AdaptiveScaffold].
  final Widget? body;

  /// An app bar to display at the top of the [AdaptiveScaffold].
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.ScaffoldPage(
        key: key,
        header: appBar,
        content: body ?? const SizedBox.shrink(),
      );
    }
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
    );
  }
}
