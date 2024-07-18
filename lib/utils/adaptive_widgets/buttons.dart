import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';

import 'icons.dart';

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
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  const AdaptiveFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.shape,
    this.padding,
  });

  @override
  Widget build(fluent_ui.BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.FilledButton(
        key: key,
        onPressed: onPressed,
        style: fluent_ui.ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(shape),
          padding: WidgetStateProperty.all(padding),
        ),
        child: child,
      );
    }
    return FilledButton(
      key: key,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
        shape: WidgetStateProperty.all(shape),
        padding: WidgetStateProperty.all(padding),
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
          backgroundColor:
              color != null ? WidgetStateProperty.all(color) : null,
          foregroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary)),
      child: child,
    );
  }
}

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected,
    this.color,
  });
  final Widget icon;
  final void Function()? onPressed;
  final bool? isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.IconButton(
        key: key,
        onPressed: onPressed,
        style: isSelected == true
            ? fluent_ui.ButtonStyle(
                backgroundColor: WidgetStateProperty.all(color))
            : null,
        icon: icon,
      );
    }
    return IconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      isSelected: isSelected,
      color: color,
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
