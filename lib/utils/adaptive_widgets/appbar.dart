import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.leading,
    this.title,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.actions,
  });

  ///The widget displayed before the [title]
  ///
  ///Usually an [Icon] widget.
  final Widget? leading;

  /// The title of this [AdaptiveAppBar].
  final Widget? title;

  /// Whether the title should be centered.
  ///
  /// Works only on android.
  final bool? centerTitle;

  /// Controls whether we should try to imply the leading widget if null.
  final bool automaticallyImplyLeading;

  /// This widget appears across the bottom of the [AdaptiveAppBar].
  final PreferredSizeWidget? bottom;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      actions: actions,
    );
  }

  @override
  Size get preferredSize {
    if (Platform.isWindows) {
      return Size.fromHeight(50.0 + (bottom == null ? 0 : kTextTabBarHeight));
    } else {
      return Size.fromHeight(
          kToolbarHeight + (bottom == null ? 0 : kTextTabBarHeight));
    }
  }
}
