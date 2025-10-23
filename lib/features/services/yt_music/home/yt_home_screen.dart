
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:ytmusic/ytmusic.dart';

import '../widgets/chip_item.dart';
import '../widgets/section_widget.dart';
import 'cubit/home_cubit.dart';


class YTHomeScreen extends StatelessWidget {
  const YTHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(sl<YTMusic>()),
      child: const YTHomeScreenView(),
    );
  }
}

class YTHomeScreenView extends StatefulWidget {

  const YTHomeScreenView({super.key});

  @override
  State<YTHomeScreenView> createState() => _YTHomeScreenViewState();
}

class _YTHomeScreenViewState extends State<YTHomeScreenView> {
    final ScrollController _scrollController = ScrollController();

    void scrollListener(){
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        context.read<HomeCubit>().loadMore();
      }
    }



  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchData();
    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder:(context, homeState) {
      if (homeState is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (homeState is HomeError) {
      return Center(
        child: Text('Error: ${homeState.message}'),
      );
    }
    if (homeState is HomeSuccess) {
      final homePage = homeState.data;
      return RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().fetchData(),
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
                    itemCount: homePage.chips.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final chip = homePage.chips[index];
                      return ChipItem(chip: chip);
                    },
                  ),
                ),
              ),
            ),
            SectionsWidget(sections: homePage.sections),
              if (homeState.loadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
          ],
        ),
      );
    }
    return const SizedBox();
    },);
  }
}
