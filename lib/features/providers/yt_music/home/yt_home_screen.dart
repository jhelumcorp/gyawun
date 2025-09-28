import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/widgets/custom_circular_progress_indicator.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/chip_item.dart';
import 'package:ytmusic/enums/section_type.dart';

import '../widgets/section_item.dart';
import 'home_state_provider.dart';

class YtHomeScreen extends ConsumerStatefulWidget {
  const YtHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtHomeScreenState();
}

class _YtHomeScreenState extends ConsumerState<YtHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref.read(homeStateNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeStateNotifierProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: state.when(
        loading: () => const Center(child: CustomCircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeStateNotifierProvider);
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 32,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.chips.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final chip = data.chips[index];
                          return ChipItem(chip: chip);
                        },
                      ),
                    ),
                  ),
                ),

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
