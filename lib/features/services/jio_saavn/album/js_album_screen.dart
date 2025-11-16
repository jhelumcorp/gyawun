import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/core/widgets/page_header_widget.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:jio_saavn/jio_saavn.dart';

import '../../../../core/widgets/section_widget.dart';
import 'cubit/album_cubit.dart';

class JSAlbumScreen extends StatelessWidget {
  const JSAlbumScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit(sl<JioSaavn>(), id),
      child: const JSAlbumScreenView(),
    );
  }
}

class JSAlbumScreenView extends StatefulWidget {
  const JSAlbumScreenView({super.key});

  @override
  State<StatefulWidget> createState() => _JSAlbumScreenViewState();
}

class _JSAlbumScreenViewState extends State<JSAlbumScreenView> {
  final ScrollController _scrollController = ScrollController();

  // void scrollListener() {
  //   final position = _scrollController.position;
  //   if (position.pixels >= position.maxScrollExtent - 200) {
  //     context.read<AlbumCubit>().loadMore();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    context.read<AlbumCubit>().fetchData();
    // _scrollController.addListener(scrollListener);
  }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(scrollListener);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Album")),
      body: BlocBuilder<AlbumCubit, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AlbumError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is AlbumSuccess) {
            final albumState = state.data;
            return CustomScrollView(
              controller: _scrollController,

              slivers: [
                if (albumState.header != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: PageHeaderWidget(
                        header: albumState.header!,
                        items: albumState.sections.firstOrNull?.items
                            .whereType<PlayableItem>()
                            .toList(),
                      ),
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
