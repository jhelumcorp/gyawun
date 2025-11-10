import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';

import '../widgets/section_header.dart';
import '../widgets/section_single_column.dart';
import 'cubit/search_cubit.dart';

class YTSearchResultView extends StatefulWidget {
  const YTSearchResultView({super.key});

  @override
  State<StatefulWidget> createState() => _YTSearchResultViewState();
}

class _YTSearchResultViewState extends State<YTSearchResultView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is SearchSuccess) {
          final searchState = state.data;
          return CustomScrollView(
            slivers: [
              for (final section in searchState.sections) ...[
                if (section.title.isNotEmpty || section.trailing != null)
                  SliverToBoxAdapter(child: SectionHeader(section: section)),
                SectionSingleColumn(items: section.items),
              ],
              const SliverToBoxAdapter(child: BottomPlayingPadding()),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
