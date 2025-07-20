import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/features/providers/yt_music/browse/browse_state_provider.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/page_header.dart';
import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
import 'package:yaru/widgets.dart';

class YtBrowseScreen extends ConsumerWidget {
  final Map<String, dynamic> body;
  const YtBrowseScreen({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(browseStateNotifierProvider(body));
    return Scaffold(
      appBar: context.isDesktop
          ? YaruWindowTitleBar(
              title: Text("Browse"),
              leading: context.canPop() ? YaruBackButton() : null,
            )
          : AppBar(title: Text("Browse")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return CustomScrollView(
            // controller: _scrollController,
            slivers: [
              if (data.header != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PageHeader(header: data.header!),
                  ),
                ),
              SliverToBoxAdapter(child: SectionSingleColumn(items: data.items)),
            ],
          );
        },
      ),
    );
  }
}
