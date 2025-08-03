// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gyawun_music/core/extensions/context_extensions.dart';
// import 'package:gyawun_music/features/providers/yt_music/search/search_state_provider.dart';
// import 'package:gyawun_music/features/providers/yt_music/widgets/section_item.dart';
// import 'package:yaru/widgets.dart';

// class YtSearchResultScreen extends ConsumerStatefulWidget {
//   final String query;
//   const YtSearchResultScreen({super.key, required this.query});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _YtSearchResultScreenState();
// }

// class _YtSearchResultScreenState extends ConsumerState<YtSearchResultScreen> {
//   // final ScrollController _scrollController = ScrollController();

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   _scrollController.addListener(() {
//   //     final position = _scrollController.position;
//   //     if (position.pixels >= position.maxScrollExtent - 200) {
//   //       ref.read(searchStateNotifierProvider(widget.query).notifier).loadMore();
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(searchStateNotifierProvider(widget.query));

//     return Scaffold(
//       body: state.when(
//         loading: () => [
//           SliverFillRemaining(
//             child: Center(child: CircularProgressIndicator()),
//           ),
//         ],
//         error: (e, _) => [
//           SliverFillRemaining(child: Center(child: Text('Error: $e'))),
//         ],
//         data: (data) => [
//           for (final section in data.sections) ...[
//             if (section.title.isNotEmpty || section.trailing != null)
//               SliverToBoxAdapter(child: SectionHeader(section: section)),
//             SectionSingleColumnSliver(items: section.items),
//           ],
//         ],
//       ),

//     );
//   }
// }
