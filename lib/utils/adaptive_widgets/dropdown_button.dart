import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class AdaptiveDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<AdaptiveDropdownMenuItem<T>>? items;
  final TextStyle? style;
  final void Function(T?)? onChanged;
  const AdaptiveDropdownButton({
    super.key,
    this.value,
    this.items,
    this.style,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.ComboBox<T>(
        value: value,
        items: items
            ?.map(
              (item) => fluent_ui.ComboBoxItem<T>(
                value: item.value,
                enabled: item.enabled,
                onTap: item.onTap,
                child: item.child,
              ),
            )
            .toList(),
        onChanged: onChanged,
      );
    }
    return DropdownButton<T>(
      style: style,
      underline: const SizedBox(),
      value: value,
      isDense: true,
      borderRadius: BorderRadius.circular(8),
      alignment: AlignmentDirectional.centerEnd,
      items: items
          ?.map(
            (item) => DropdownMenuItem(
              value: item.value,
              enabled: item.enabled,
              onTap: item.onTap,
              child: item.child,
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class AdaptiveDropdownMenuItem<T> {
  final Widget child;
  final T? value;
  final bool enabled;
  final void Function()? onTap;
  AdaptiveDropdownMenuItem(
      {required this.child, this.value, this.enabled = true, this.onTap});
}
