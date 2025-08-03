import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/features/providers/yt_music/search/search_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/search_top_bar.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';

class YtSearchScreen extends ConsumerStatefulWidget {
  const YtSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtSearchScreenState();
}

class _YtSearchScreenState extends ConsumerState<YtSearchScreen> {
  String? query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SearchTopBar(
              onSubmit: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ];
        },

        body: CustomScrollView(
          slivers: [
            if (query == null)
              SliverList.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              )
            else
              ..._searchResults(query!),
          ],
        ),
      ),
    );
  }

  List<Widget> _searchResults(String query) {
    return ref
        .watch(searchStateNotifierProvider(query))
        .when(
          loading: () => [
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (e, _) => [
            SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ],
          data: (data) => [
            for (final section in data.sections) ...[
              if (section.title.isNotEmpty || section.trailing != null)
                SliverToBoxAdapter(child: SectionHeader(section: section)),
              SectionSingleColumnSliver(items: section.items),
            ],
          ],
        );
  }
}
