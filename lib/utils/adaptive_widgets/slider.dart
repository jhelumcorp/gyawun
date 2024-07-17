import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';

class AdaptiveSlider extends StatelessWidget {
  final double value;
  final bool disabled;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool vertical;
  final void Function(double)? onChanged;
  const AdaptiveSlider(
      {required this.value,
      this.disabled = false,
      this.onChanged,
      this.min = 0,
      this.max = 1,
      this.divisions,
      this.label,
      this.vertical = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.Slider(
        min: min,
        max: max,
        label: label,
        divisions: divisions,
        value: value,
        vertical: vertical,
        onChanged: disabled ? null : onChanged,
      );
    }
    return RotatedBox(
      quarterTurns: vertical ? 3 : 0,
      child: Slider(
        value: value,
        min: min,
        max: max,
        label: label,
        divisions: divisions,
        onChanged: disabled ? null : onChanged,
      ),
    );
  }
}
