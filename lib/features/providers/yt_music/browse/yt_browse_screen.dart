import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/features/providers/yt_music/browse/browse_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
import 'package:ytmusic/enums/section_type.dart';

class YtBrowseScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> body;
  const YtBrowseScreen({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtBrowseScreenState();
}

class _YtBrowseScreenState extends ConsumerState<YtBrowseScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref.read(browseStateNotifierProvider(widget.body).notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(browseStateNotifierProvider(widget.body));

    return Scaffold(
      appBar: AppBar(title: Text("Browse")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (data.header != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PageHeader(header: data.header!),
                  ),
                ),

              // Loop through sections
              for (final section in data.sections) ...[
                if (section.title.isNotEmpty || section.trailing != null)
                  SliverToBoxAdapter(child: SectionHeader(section: section)),

                if (section.type == YTSectionType.row)
                  SectionRowSliver(items: section.items),

                if (section.type == YTSectionType.multiColumn)
                  SectionMultiColumnSliver(
                    items: section.items,
                    // controller: _scrollController,
                  ),

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
          );
        },
      ),
    );
  }
}
