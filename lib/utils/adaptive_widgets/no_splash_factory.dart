import 'package:flutter/material.dart';

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    onRemoved,
  }) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
      color: color,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  @override
  final Color color; // Color for onTap effect

  NoSplash({
    required super.controller,
    required super.referenceBox,
    required this.color,
  }) : super(color: color);

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()
      ..color = color.withAlpha(50); // Adjust opacity as needed
    canvas.drawRect(Offset.zero & referenceBox.size, paint);
  }
}
