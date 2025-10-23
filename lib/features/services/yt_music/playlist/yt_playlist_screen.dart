import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/services/yt_music/playlist/cubit/playlist_cubit.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/section_widget.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTPlaylistScreen extends StatelessWidget {
  final Map<String, dynamic> body;
  const YTPlaylistScreen({super.key,required this.body});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistCubit(sl<YTMusic>(),body),
      child: const YTPlaylistScreenView(),
    );
  }
}

class YTPlaylistScreenView extends StatefulWidget {
  
  const YTPlaylistScreenView({super.key,});

  @override
  State<StatefulWidget> createState() => _YTPlaylistScreenViewState();
}

class _YTPlaylistScreenViewState extends State<YTPlaylistScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener(){
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
      appBar:AppBar(title: Text("Playlist")),
      body: BlocBuilder<PlaylistCubit,PlaylistState>(builder:(context, state) {
        if (state is PlaylistLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is PlaylistError) {
      return Center(
        child: Text('Error: ${state.message}'),
      );
    }
        if(state is PlaylistSuccess){
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }
        return SizedBox();
      },)
    );
  }
}
