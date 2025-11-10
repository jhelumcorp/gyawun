import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/section_widget.dart';
import 'package:ytmusic/yt_music_base.dart';

import 'cubit/podcast_cubit.dart';

class YTPodcastScreen extends StatelessWidget {
  const YTPodcastScreen({super.key, required this.body});
  final Map<String, dynamic> body;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PodcastCubit(sl<YTMusic>(), body),
      child: const YTPodcastScreenView(),
    );
  }
}

class YTPodcastScreenView extends StatefulWidget {
  const YTPodcastScreenView({super.key});

  @override
  State<StatefulWidget> createState() => _YTPodcastScreenViewState();
}

class _YTPodcastScreenViewState extends State<YTPodcastScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<PodcastCubit>().loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PodcastCubit>().fetchData();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Podcast")),
      body: BlocBuilder<PodcastCubit, PodcastState>(
        builder: (context, state) {
          if (state is PodcastLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PodcastError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is PodcastSuccess) {
            final albumState = state.data;
            return CustomScrollView(
              controller: _scrollController,

              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PageHeader(header: albumState.header),
                  ),
                ),

                SectionsWidget(sections: albumState.sections),
                if (state.loadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                const SliverToBoxAdapter(child: BottomPlayingPadding()),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
