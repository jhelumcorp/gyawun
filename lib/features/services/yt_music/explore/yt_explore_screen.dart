import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/services/yt_music/explore/cubit/explore_cubit.dart';
import 'package:ytmusic/ytmusic.dart';

import '../widgets/section_widget.dart';

class YTExploreScreen extends StatelessWidget {
  const YTExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreCubit(sl<YTMusic>())..fetch(),
      child: const YTExploreScreenView(),
    );
  }
}

class YTExploreScreenView extends StatelessWidget {
  const YTExploreScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCubit, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ExploreError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is ExploreSuccess) {
          final exploreState = state.data;
          return CustomScrollView(
            slivers: [
              SectionsWidget(sections: exploreState),
              const SliverToBoxAdapter(child: BottomPlayingPadding()),
            ],
          );
        }
        return const SizedBox();
      },
    );
    // ListView.builder(
    //   itemCount: 100,
    //   itemBuilder: (context, index) {
    //     return ListTile(title: Text('Item $index'));
    //   },
    // );
  }
}
