import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const AdaptiveSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.ToggleSwitch(checked: value, onChanged: onChanged);
    }
    return Switch(value: value, onChanged: onChanged);
  }
}
