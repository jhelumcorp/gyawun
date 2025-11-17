import 'package:flutter/material.dart';

class GroupTitle extends StatelessWidget {
  const GroupTitle({super.key, required this.title, this.paddingTop});
  final String title;
  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop ?? 12, left: 20, right: 20, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
