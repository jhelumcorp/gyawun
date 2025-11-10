import 'package:flutter/material.dart';

AlertDialog promptDialog(BuildContext context, {String? title}) {
  String value = "";
  return AlertDialog(
    title: Text(
      title ?? 'Prompt Dialog',
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
    contentPadding: const EdgeInsetsGeometry.all(16),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Enter here",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (v) => value = v,
        ),
      ],
    ),
    actions: [
      FilledButton(
        onPressed: () {
          Navigator.pop(context, value);
        },
        child: const Text("Done"),
      ),
    ],
  );
}
