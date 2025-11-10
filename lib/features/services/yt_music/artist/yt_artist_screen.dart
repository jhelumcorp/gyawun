import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/widgets/bottom_playing_padding.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/artist_page_header.dart';
import 'package:gyawun_music/features/services/yt_music/widgets/section_widget.dart';
import 'package:ytmusic/yt_music_base.dart';

import 'cubit/artist_cubit.dart';

class YTArtistScreen extends StatelessWidget {
  const YTArtistScreen({super.key, required this.body});
  final Map<String, dynamic> body;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistCubit(sl<YTMusic>(), body),
      child: const YTArtistScreenView(),
    );
  }
}

class YTArtistScreenView extends StatefulWidget {
  const YTArtistScreenView({super.key});

  @override
  State<YTArtistScreenView> createState() => _YTArtistScreenViewState();
}

class _YTArtistScreenViewState extends State<YTArtistScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<ArtistCubit>().loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ArtistCubit>().fetchData();
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
      appBar: context.isWideScreen ? AppBar() : null,
      body: BlocBuilder<ArtistCubit, ArtistState>(
        builder: (context, state) {
          if (state is ArtistLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ArtistError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is ArtistSuccess) {
            final artistState = state.data;
            final thumbnail = artistState.header.thumbnails.lastOrNull;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (!context.isWideScreen)
                  SliverAppBar(
                    pinned: true,
                    leading: BackButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                    ),
                    expandedHeight: min(
                      (thumbnail?.height ?? 400).toDouble(),
                      300,
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxHeight = min(
                          (thumbnail?.height ?? 400).toDouble(),
                          300,
                        );
                        final t =
                            ((constraints.maxHeight - kToolbarHeight) /
                                    (maxHeight - kToolbarHeight))
                                .clamp(0.0, 1.0);

                        final paddingLeft = lerpDouble(16, 72, 1 - t)!;

                        return FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(
                            left: paddingLeft,
                            bottom: 16,
                          ),
                          title: Text(
                            artistState.header.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (thumbnail?.url != null)
                                CachedNetworkImage(
                                  imageUrl: thumbnail!.url,
                                  fit: BoxFit.cover,
                                ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Theme.of(context).scaffoldBackgroundColor,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ArtistPageHeader(header: artistState.header),
                  ),
                ),

                SectionsWidget(sections: artistState.sections),

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
