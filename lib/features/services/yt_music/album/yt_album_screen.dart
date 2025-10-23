import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/features/services/yt_music/album/cubit/album_cubit.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/section_widget.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTAlbumScreen extends StatelessWidget {
  final Map<String, dynamic> body;
  const YTAlbumScreen({super.key,required this.body});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit(sl<YTMusic>(),body),
      child: const YTAlbumScreenView(),
    );
  }
}

class YTAlbumScreenView extends StatefulWidget {
  
  const YTAlbumScreenView({super.key,});

  @override
  State<StatefulWidget> createState() => _YTAlbumScreenViewState();
}

class _YTAlbumScreenViewState extends State<YTAlbumScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener(){
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        context.read<AlbumCubit>().loadMore();
      }
    }

  @override
  void initState() {
    super.initState();
    context.read<AlbumCubit>().fetchData();
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
      appBar:AppBar(title: Text("Album")),
      body: BlocBuilder<AlbumCubit,AlbumState>(builder:(context, state) {
        if (state is AlbumLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is AlbumError) {
      return Center(
        child: Text('Error: ${state.message}'),
      );
    }
        if(state is AlbumSuccess){
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
