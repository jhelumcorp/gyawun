import 'package:flutter/material.dart';

class ColorIcon extends StatelessWidget {
  const ColorIcon({
    required this.icon,
    required this.color,
    super.key,
  });
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ));
  }
}
