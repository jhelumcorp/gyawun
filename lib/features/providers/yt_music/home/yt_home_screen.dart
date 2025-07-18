import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/section_item.dart';
import 'home_state_provider.dart';

class YtHomeScreen extends ConsumerStatefulWidget {
  const YtHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YtHomeScreenState();
}

class _YtHomeScreenState extends ConsumerState<YtHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        ref.read(homeStateNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeStateNotifierProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeStateNotifierProvider);
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: data.sections.length + 1,
              scrollDirection: Axis.vertical,
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
          );
        },
      ),
    );
  }
}
