import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class AdaptivePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  AdaptivePageRoute({required this.builder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: fluent_ui.DrillInPageTransition(
        animation: CurvedAnimation(
          parent: animation,
          curve: fluent_ui.FluentTheme.of(context).animationCurve,
        ),
        child: result,
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  static PageRoute<T> create<T>(WidgetBuilder builder) {
    if (Platform.isWindows) {
      return fluent_ui.FluentPageRoute<T>(builder: builder);
    } else {
      return CupertinoPageRoute<T>(builder: builder);
    }
  }
}
