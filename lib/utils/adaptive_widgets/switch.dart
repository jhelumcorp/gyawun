import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const AdaptiveSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(value: value, onChanged: onChanged);
  }
}
