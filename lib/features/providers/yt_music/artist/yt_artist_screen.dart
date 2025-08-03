import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/extensions/list_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/artist/artist_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/artist_page_header.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
import 'package:yaru/widgets.dart';
import 'package:ytmusic/enums/section_type.dart';

class YtArtistScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> body;
  const YtArtistScreen({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtArtistScreenState();
}

class _YtArtistScreenState extends ConsumerState<YtArtistScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref.read(artistStateNotifierProvider(widget.body).notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(artistStateNotifierProvider(widget.body));

    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              heroTag: "titlebar",
              title: Text("Artist"),
              leading: context.canPop() ? YaruBackButton() : null,
            )
          : null,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final thumbnail = data.header!.thumbnails.byWidth(
            MediaQuery.sizeOf(context).width.toInt(),
          );
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (data.header != null && !context.isWideViewport)
                SliverAppBar(
                  pinned: true,

                  expandedHeight: context.isWideViewport
                      ? 0
                      : min(thumbnail.height.toDouble(), 300),
                  flexibleSpace: context.isWideViewport
                      ? null
                      : FlexibleSpaceBar(
                          title: Stack(children: [Text(data.header!.title)]),
                          background: Container(
                            padding: EdgeInsets.all(0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.isWideViewport ? 8 : 0,
                              ),
                              child: Stack(
                                children: [
                                  // Image
                                  CachedNetworkImage(
                                    imageUrl: thumbnail.url,
                                    fit: BoxFit.fitHeight,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  // Gradient overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ArtistPageHeader(header: data.header!),
                ),
              ),

              // Loop through sections
              for (final section in data.sections) ...[
                if (section.title.isNotEmpty || section.trailing != null)
                  SliverToBoxAdapter(child: SectionHeader(section: section)),

                if (section.type == YTSectionType.row)
                  SectionRowSliver(items: section.items),

                if (section.type == YTSectionType.multiColumn)
                  SectionMultiColumnSliver(items: section.items),

                if (section.type == YTSectionType.singleColumn)
                  SectionSingleColumnSliver(items: section.items),

                if (section.type == YTSectionType.grid)
                  SectionGridSliver(items: section.items),
              ],

              if (data.isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
