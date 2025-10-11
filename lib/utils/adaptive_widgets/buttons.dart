import 'package:flutter/material.dart';

import 'icons.dart';

class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const AdaptiveButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}

class AdaptiveFilledButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
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

class AdaptiveOutlinedButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  const AdaptiveOutlinedButton(
      {super.key, required this.child, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
    return AdaptiveIconButton(
      icon: Icon(AdaptiveIcons.back),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}
