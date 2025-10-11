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
