import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:ytmusic/ytmusic.dart';

import '../widgets/section_widget.dart';
import 'cubit/chip_cubit.dart';

class YtChipScreen extends StatelessWidget {
  final Map<String, dynamic> body;
  final String title;
  const YtChipScreen({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChipCubit(sl<YTMusic>(), body),
      child: YTChipScreenView(title: title),
    );
  }
}

class YTChipScreenView extends StatefulWidget {
  final String title;

  const YTChipScreenView({super.key, required this.title});

  @override
  State<YTChipScreenView> createState() => _YTChipScreenViewState();
}

class _YTChipScreenViewState extends State<YTChipScreenView> {
  final ScrollController _scrollController = ScrollController();

  void scrollListener() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<ChipCubit>().loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ChipCubit>().fetchData();
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
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<ChipCubit, ChipState>(
        builder: (context, chipState) {
          if (chipState is ChipLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chipState is ChipError) {
            return Center(child: Text('Error: ${chipState.message}'));
          }
          if (chipState is ChipSuccess) {
            final homePage = chipState.data;
            return RefreshIndicator(
              onRefresh: () => context.read<ChipCubit>().fetchData(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SectionsWidget(sections: homePage.sections),
                  if (chipState.loadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gyawun_music/features/services/yt_music/chip/chip_state_provider.dart';

// import '../widgets/section_widget.dart';

// class YtChipScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> body;
//   final String title;
//   const YtChipScreen({super.key, required this.body,required this.title});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _YtChipScreenState();
// }

// class _YtChipScreenState extends ConsumerState<YtChipScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     _scrollController.addListener(() {
//       final position = _scrollController.position;
//       if (position.pixels >= position.maxScrollExtent - 200) {
//         ref.read(chipStateNotifierProvider(widget.body).notifier).loadMore();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(chipStateNotifierProvider(widget.body));

//     return Scaffold(
//       appBar:AppBar(title: Text(widget.title)),
//       body: state.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//         data: (data) {
//           return RefreshIndicator(
//             onRefresh: () async {
//               ref.invalidate(chipStateNotifierProvider(widget.body));
//             },
//             child: CustomScrollView(
//               controller: _scrollController,
//               slivers: [
//                 SectionsWidget(sections: data.sections),

//                 if (data.isLoadingMore)
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
