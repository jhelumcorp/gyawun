import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/core/widgets/page_header_widget.dart';
import 'package:gyawun_music/core/widgets/section_widget.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/cubit/playlist_cubit.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTPlaylistScreen extends StatelessWidget {
  const YTPlaylistScreen({super.key, required this.body});
  final Map<String, dynamic> body;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistCubit(sl<YTMusic>(), body),
      child: const YTPlaylistScreenView(),
    );
  }
}

class YTPlaylistScreenView extends StatefulWidget {
  const YTPlaylistScreenView({super.key});

  @override
  State<StatefulWidget> createState() => _YTPlaylistScreenViewState();
}

class _YTPlaylistScreenViewState extends State<YTPlaylistScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<PlaylistCubit>().loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PlaylistCubit>().fetchData();
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
      appBar: AppBar(title: const Text("Playlist")),
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlaylistError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is PlaylistSuccess) {
            final playlistState = state.data;
            return CustomScrollView(
              controller: _scrollController,

              slivers: [
                if (playlistState.header != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: PageHeaderWidget(header: playlistState.header!),
                    ),
                  ),

                SectionsWidget(sections: playlistState.sections),
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
