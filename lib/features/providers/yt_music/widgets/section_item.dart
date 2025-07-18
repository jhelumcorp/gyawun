import 'dart:convert';
import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_exxtensions.dart';
import 'package:ytmusic/enums/enums.dart';
import 'package:ytmusic/models/section.dart';

import 'section_item_tile.dart';

class SectionItem extends StatelessWidget {
  const SectionItem({super.key, required this.section});

  final YTSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              if (section.trailing != null)
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    if (section.trailing!.isPlayable == false) {
                      context.go(
                        '/home/browse/${jsonEncode(section.trailing!.endpoint)}',
                      );
                    }
                  },
                  icon: Icon(
                    section.trailing!.isPlayable
                        ? Icons.play_arrow
                        : Icons.arrow_forward,
                  ),
                  label: Text(section.trailing!.text),
                ),
            ],
          ),
        ),
        SizedBox(height: 2),

        if (section.type == YTSectionType.row) SectionRow(items: section.items),
        if (section.type == YTSectionType.multiColumn)
          SectionMultiColumn(items: section.items),
        if (section.type == YTSectionType.singleColumn)
          SectionSingleColumn(items: section.items),
      ],
    );
  }
}

class SectionRow extends StatelessWidget {
  const SectionRow({super.key, required this.items});

  final List<YTSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.isWideScreen ? 270 : 216,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(width: 4),
        itemBuilder: (context, index) {
          final item = items[index];
          return SectionItemRowTile(item: item);
        },
      ),
    );
  }
}

class SectionMultiColumn extends StatelessWidget {
  const SectionMultiColumn({super.key, required this.items});

  final List<YTSectionItem> items;

  @override
  Widget build(BuildContext context) {
    final horizontalPageController = PageController(
      viewportFraction: 350 / MediaQuery.sizeOf(context).width,
    );
    final num = items.length <= 5 ? items.length : 4;
    var pages = items.length ~/ num;
    pages = (pages * num) < items.length ? pages + 1 : pages;
    return ExpandablePageView.builder(
      controller: horizontalPageController,
      padEnds: false,
      itemCount: pages,
      itemBuilder: (context, index) {
        int start = index * num;
        int end = start + num;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: items.sublist(start, min(end, items.length)).map((item) {
              return SectionItemColumnTile(item: item);
            }).toList(),
          ),
        );
      },
    );
  }
}

class SectionSingleColumn extends StatelessWidget {
  const SectionSingleColumn({super.key, required this.items});

  final List<YTSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          SectionItemColumnTile(item: items[index]),
    );
  }
}
