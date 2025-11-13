import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

class SectionButtonTile extends StatelessWidget {
  const SectionButtonTile({super.key, required this.item});
  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => YTBrowseScreen(body: item.endpoint, title: item.title),
          //   ),
          // );

          context.push('/ytmusic/browse/${jsonEncode(item.endpoint)}/${item.title}');
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(item.title, style: Theme.of(context).textTheme.labelLarge, maxLines: 1),
        ),
      ),
    );
  }
}
