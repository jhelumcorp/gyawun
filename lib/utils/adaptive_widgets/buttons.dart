import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

class AdaptiveButton extends fluent_ui.StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const AdaptiveButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(fluent_ui.BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.Button(
        key: key,
        onPressed: onPressed,
        style: fluent_ui.ButtonStyle(
            backgroundColor: WidgetStateProperty.all(color)),
        child: child,
      );
    }
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}

class AdaptiveFilledButton extends fluent_ui.StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const AdaptiveFilledButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(fluent_ui.BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.FilledButton(
        key: key,
        onPressed: onPressed,
        style: fluent_ui.ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
        ),
        child: child,
      );
    }
    return FilledButton(
      key: key,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: child,
    );
  }
}

class AdaptiveOutlinedButton extends fluent_ui.StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const AdaptiveOutlinedButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(fluent_ui.BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.OutlinedButton(
        key: key,
        onPressed: onPressed,
        style: fluent_ui.ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
        ),
        child: child,
      );
    }
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: color != null ? WidgetStateProperty.all(color) : null,
      ),
      child: child,
    );
  }
}

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.IconButton(
        key: key,
        onPressed: onPressed,
        icon: icon,
      );
    }
    return IconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
    );
  }
}

class AdaptiveBackButton extends StatelessWidget {
  const AdaptiveBackButton({super.key});

  @override
  fluent_ui.Widget build(fluent_ui.BuildContext context) {
    return AdaptiveIconButton(
      icon: Icon(AdaptiveIcons.back),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}
