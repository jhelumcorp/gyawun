import 'dart:io';

import 'package:flutter/material.dart';

import 'no_splash_factory.dart';

class AdaptiveInkWell extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressCallback? onDoubleTap;
  final GestureLongPressCallback? onSecondaryTap;
  final BorderRadius? borderRadius;
  final bool selected;

  const AdaptiveInkWell({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.borderRadius,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          onDoubleTap: enabled ? onDoubleTap : null,
          onSecondaryTap: enabled ? onSecondaryTap : null,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
          splashFactory: (Platform.isWindows) ? const NoSplashFactory() : null,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: child,
          ),
        ),
      ),
    );
  }
}
