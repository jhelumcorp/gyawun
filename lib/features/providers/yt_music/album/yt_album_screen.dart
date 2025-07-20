import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/playlist/playlist_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
import 'package:yaru/widgets.dart';

class YtAlbumScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> body;
  const YtAlbumScreen({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtAlbumScreenState();
}

class _YtAlbumScreenState extends ConsumerState<YtAlbumScreen> {
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
              heroTag: "titlebar",
              title: Text("Album"),
              leading: context.canPop() ? YaruBackButton() : null,
            )
          : AppBar(title: Text("Album")),
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
              SliverList.builder(
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
            ],
          );
        },
      ),
    );
  }
}
