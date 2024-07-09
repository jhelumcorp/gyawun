import 'dart:io';

import 'package:flutter/material.dart';

import 'no_splash_factory.dart';

class AdaptiveListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? description;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressCallback? onDoubleTap;
  final GestureLongPressCallback? onSecondaryTap;
  final bool selected;

  const AdaptiveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.description,
    this.isThreeLine = false,
    this.dense = false,
    this.contentPadding,
    this.margin,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: dense ? 14.0 : 16.0,
    );

    final TextStyle? subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: dense ? 12.0 : 14.0,
    );

    final TextStyle? descriptionStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: dense ? 12.0 : 14.0,
    );

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          onDoubleTap: enabled ? onDoubleTap : null,
          onSecondaryTap: enabled ? onSecondaryTap : null,
          borderRadius: BorderRadius.circular(4),
          splashFactory: Platform.isWindows ? const NoSplashFactory() : null,
          child: Container(
            padding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            decoration: BoxDecoration(
              color:
                  selected ? theme.colorScheme.primary.withOpacity(0.1) : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 16.0),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null) ...[
                            DefaultTextStyle(
                              style: titleStyle!,
                              child: title!,
                            ),
                            if (subtitle != null || isThreeLine)
                              SizedBox(height: dense ? 2.0 : 4.0),
                          ],
                          if (subtitle != null || isThreeLine) ...[
                            DefaultTextStyle(
                              style: subtitleStyle!,
                              child: subtitle ?? Container(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 16.0),
                      trailing!,
                    ],
                  ],
                ),
                if (subtitle != null || isThreeLine)
                  SizedBox(height: dense ? 2.0 : 4.0),
                if (description != null) ...[
                  DefaultTextStyle(
                    style: descriptionStyle!,
                    child: description!,
                  ),
                ],
                if (description != null) const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
