import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/browse/yt_browse_screen.dart';
import 'package:ytmusic/enums/enums.dart';
import 'package:ytmusic/models/section.dart';

import 'section_item_tile.dart';

class SectionItem extends StatefulWidget {
  const SectionItem({super.key, required this.section});

  final YTSection section;

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  late PageController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = PageController(
      viewportFraction: 350 / MediaQuery.sizeOf(context).width,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                widget.section.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              if (widget.section.trailing != null)
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    if (widget.section.trailing!.isPlayable == false) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => YtBrowseScreen(
                            body: widget.section.trailing!.endpoint.cast(),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    widget.section.trailing!.isPlayable
                        ? Icons.play_arrow
                        : Icons.arrow_forward,
                  ),
                  label: Text(widget.section.trailing!.text),
                ),
            ],
          ),
        ),
        SizedBox(height: 2),

        if (widget.section.type == YTSectionType.row)
          SectionRow(items: widget.section.items),
        if (widget.section.type == YTSectionType.multiColumn)
          SectionMultiColumn(
            items: widget.section.items,
            controller: controller,
          ),
        if (widget.section.type == YTSectionType.singleColumn)
          SectionSingleColumn(items: widget.section.items),
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
        addAutomaticKeepAlives: false,
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
  final PageController controller;
  const SectionMultiColumn({
    super.key,
    required this.items,
    required this.controller,
  });

  final List<YTSectionItem> items;

  @override
  Widget build(BuildContext context) {
    final num = items.length <= 5 ? items.length : 4;
    var pages = items.length ~/ num;
    pages = (pages * num) < items.length ? pages + 1 : pages;
    return ExpandablePageView.builder(
      controller: controller,
      padEnds: false,
      itemCount: pages,
      itemBuilder: (context, index) {
        int start = index * num;
        int end = start + num;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
      padding: EdgeInsets.symmetric(horizontal: 8),
      addAutomaticKeepAlives: false,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          SectionItemColumnTile(item: items[index]),
    );
  }
}
