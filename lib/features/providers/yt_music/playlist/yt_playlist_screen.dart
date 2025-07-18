import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_exxtensions.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/playlist_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
import 'package:yaru/widgets.dart';
import 'package:ytmusic/models/browse_page.dart';

class YtPlaylistScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> body;
  const YtPlaylistScreen({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YtPlaylistScreenState();
}

class _YtPlaylistScreenState extends ConsumerState<YtPlaylistScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref
            .read(playlistStateNotifierProvider(widget.body).notifier)
            .loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playlistStateNotifierProvider(widget.body));

    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              title: Text("Playlist"),
              leading: context.canPop() ? YaruBackButton() : null,
            )
          : AppBar(title: Text("Playlist")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (data.header != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PageHeader(header: data.header!),
                  ),
                ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  primary: false,
                  itemCount: data.sections.length + 1,
                  itemBuilder: (context, index) {
                    if (index < data.sections.length) {
                      final section = data.sections[index];
                      return SectionItem(section: section);
                    } else {
                      if (data.continuation != null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final YTPageHeader header;
  const PageHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header.thumbnails.lastOrNull?.url != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: header.thumbnails.lastOrNull!.url,
              height: 300,
              width: 300,
            ),
          ),
        Text(header.title),
        Text(header.subtitle),
        Text(header.secondSubtitle),
        Text(header.description),
      ],
    );
  }
}
