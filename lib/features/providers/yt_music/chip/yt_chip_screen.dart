import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/chip/chip_state_provider.dart';
import 'package:yaru/yaru.dart';
import 'package:ytmusic/enums/section_type.dart';

import '../widgets/section_item.dart';

class YtChipScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> body;
  const YtChipScreen({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtChipScreenState();
}

class _YtChipScreenState extends ConsumerState<YtChipScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref.read(chipStateNotifierProvider(widget.body).notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chipStateNotifierProvider(widget.body));

    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              title: Text(""),
              leading: context.canPop() ? YaruBackButton() : null,
            )
          : AppBar(title: Text("Playlist")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(chipStateNotifierProvider(widget.body));
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Loop through sections
                for (final section in data.sections) ...[
                  if (section.title.isNotEmpty || section.trailing != null)
                    SliverToBoxAdapter(child: SectionHeader(section: section)),

                  if (section.type == YTSectionType.row)
                    SectionRowSliver(items: section.items),

                  if (section.type == YTSectionType.multiColumn)
                    SectionMultiColumnSliver(items: section.items),

                  if (section.type == YTSectionType.singleColumn)
                    SectionSingleColumnSliver(items: section.items),

                  if (section.type == YTSectionType.grid)
                    SectionGridSliver(items: section.items),
                ],

                if (data.isLoadingMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
