import 'package:flutter/material.dart';

class AdaptiveProgressRing extends StatelessWidget {
  final double? value;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? color;

  /// Creates progress ring.
  ///
  /// [value], if non-null, must be in the range of 0 to 100
  ///
  /// [strokeWidth] must be equal or greater than 0
  const AdaptiveProgressRing({
    super.key,
    this.value,
    this.strokeWidth = 4.5,
    this.backgroundColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      strokeWidth: strokeWidth,
      backgroundColor: backgroundColor,
      color: color,
    );
  }
}
