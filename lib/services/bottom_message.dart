import 'package:flutter/material.dart';

class BottomMessage {
  static showText(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: duration,
      ),
    );
  }
}
