import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/core/widgets/page_header_widget.dart';
import 'package:gyawun_music/core/widgets/section_widget.dart';
import 'package:gyawun_music/features/services/yt_music/browse/cubit/browse_cubit.dart';
import 'package:ytmusic/yt_music_base.dart';

class YTBrowseScreen extends StatelessWidget {
  const YTBrowseScreen({super.key, required this.body, this.title});
  final Map<String, dynamic> body;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrowseCubit(sl<YTMusic>(), body)..fetchData(),
      child: YTBrowseScreenView(title: title),
    );
  }
}

class YTBrowseScreenView extends StatelessWidget {
  YTBrowseScreenView({super.key, this.title});
  final String? title;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? "Browse")),
      body: BlocBuilder<BrowseCubit, BrowseState>(
        builder: (context, state) {
          if (state is BrowseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BrowseError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is BrowseSuccess) {
            final browseState = state.data;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (browseState.header != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: PageHeaderWidget(header: browseState.header!),
                    ),
                  ),

                SectionsWidget(sections: browseState.sections),

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
